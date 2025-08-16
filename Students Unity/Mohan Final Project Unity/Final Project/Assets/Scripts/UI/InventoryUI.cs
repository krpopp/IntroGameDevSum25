using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections.Generic;

public class InventoryUI : MonoBehaviour
{
    [Header("Inventory Display")]
    [SerializeField] private GameObject inventoryPanel;
    [SerializeField] private Transform itemContainer;
    [SerializeField] private GameObject itemSlotPrefab;
    [SerializeField] private int maxVisibleSlots = 10;
    
    [Header("Item Display")]
    [SerializeField] private Image[] itemIcons;
    [SerializeField] private TextMeshProUGUI[] itemCounts;
    [SerializeField] private GameObject[] itemSlots;
    
    [Header("Visual Settings")]
    [SerializeField] private Color normalSlotColor = Color.white;
    [SerializeField] private Color highlightSlotColor = Color.yellow;
    [SerializeField] private Color emptySlotColor = Color.gray;
    [SerializeField] private bool showItemCounts = true;
    [SerializeField] private bool showItemNames = false;
    
    [Header("Animation")]
    [SerializeField] private bool enableAnimations = true;
    [SerializeField] private float itemAddAnimationDuration = 0.3f;
    [SerializeField] private float itemRemoveAnimationDuration = 0.2f;
    [SerializeField] private Vector3 itemAddScale = Vector3.one * 1.2f;
    
    [Header("Audio")]
    [SerializeField] private string itemAddSoundId = "item_add";
    [SerializeField] private string itemRemoveSoundId = "item_remove";
    [SerializeField] private string itemSelectSoundId = "item_select";
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // State
    private List<InventoryItem> currentItems = new List<InventoryItem>();
    private int selectedSlotIndex = -1;
    private bool isInventoryVisible = false;
    
    // Animation
    private Dictionary<int, Vector3> originalScales = new Dictionary<int, Vector3>();
    private Dictionary<int, Coroutine> activeAnimations = new Dictionary<int, Coroutine>();
    
    private void Awake()
    {
        InitializeInventoryUI();
    }
    
    private void Start()
    {
        SubscribeToEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnItemCollected += OnItemCollected;
        GameEvents.OnInventoryChanged += OnInventoryChanged;
        GameEvents.OnGameStateChanged += OnGameStateChanged;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnItemCollected -= OnItemCollected;
        GameEvents.OnInventoryChanged -= OnInventoryChanged;
        GameEvents.OnGameStateChanged -= OnGameStateChanged;
    }
    
    private void InitializeInventoryUI()
    {
        // Initialize item slots if not assigned
        if (itemSlots == null || itemSlots.Length == 0)
        {
            CreateItemSlots();
        }
        
        // Store original scales for animations
        for (int i = 0; i < itemSlots.Length; i++)
        {
            if (itemSlots[i] != null)
            {
                originalScales[i] = itemSlots[i].transform.localScale;
            }
        }
        
        // Set initial state
        UpdateInventoryDisplay();
        
        if (debugMode)
        {
            Debug.Log("Inventory UI initialized");
        }
    }
    
    private void CreateItemSlots()
    {
        if (itemContainer == null || itemSlotPrefab == null) return;
        
        itemSlots = new GameObject[maxVisibleSlots];
        itemIcons = new Image[maxVisibleSlots];
        itemCounts = new TextMeshProUGUI[maxVisibleSlots];
        
        for (int i = 0; i < maxVisibleSlots; i++)
        {
            GameObject slot = Instantiate(itemSlotPrefab, itemContainer);
            itemSlots[i] = slot;
            
            // Get components
            itemIcons[i] = slot.GetComponentInChildren<Image>();
            itemCounts[i] = slot.GetComponentInChildren<TextMeshProUGUI>();
            
            // Set up slot
            int slotIndex = i; // Capture index for lambda
            slot.name = $"ItemSlot_{i}";
            
            // Add click handler
            Button slotButton = slot.GetComponent<Button>();
            if (slotButton != null)
            {
                slotButton.onClick.AddListener(() => OnSlotClicked(slotIndex));
            }
        }
    }
    
    // Event handlers
    private void OnItemCollected(string itemId)
    {
        UpdateInventory();
    }
    
    private void OnInventoryChanged()
    {
        UpdateInventory();
    }
    
    private void OnGameStateChanged(GameState newState)
    {
        // Show/hide inventory based on game state
        bool shouldShow = newState == GameState.Playing || newState == GameState.Dialogue;
        SetInventoryVisible(shouldShow);
    }
    
    // Public API
    public void UpdateInventory()
    {
        // Get current inventory from player
        var player = FindObjectOfType<PlayerInventory>();
        if (player != null)
        {
            currentItems = player.GetAllItems();
        }
        
        UpdateInventoryDisplay();
        
        if (debugMode)
        {
            Debug.Log($"Inventory updated: {currentItems.Count} items");
        }
    }
    
    public void UpdateInventoryDisplay()
    {
        for (int i = 0; i < itemSlots.Length; i++)
        {
            if (itemSlots[i] == null) continue;
            
            if (i < currentItems.Count)
            {
                // Show item
                ShowItemInSlot(i, currentItems[i]);
            }
            else
            {
                // Hide slot
                HideItemSlot(i);
            }
        }
    }
    
    public void ShowItemInSlot(int slotIndex, InventoryItem item)
    {
        if (slotIndex < 0 || slotIndex >= itemSlots.Length) return;
        
        // Show slot
        itemSlots[slotIndex].SetActive(true);
        
        // Set icon
        if (itemIcons[slotIndex] != null)
        {
            itemIcons[slotIndex].sprite = item.icon;
            itemIcons[slotIndex].color = Color.white;
        }
        
        // Set count
        if (itemCounts[slotIndex] != null)
        {
            if (showItemCounts && item.quantity > 1)
            {
                itemCounts[slotIndex].text = item.quantity.ToString();
                itemCounts[slotIndex].gameObject.SetActive(true);
            }
            else
            {
                itemCounts[slotIndex].gameObject.SetActive(false);
            }
        }
        
        // Set slot color
        Image slotImage = itemSlots[slotIndex].GetComponent<Image>();
        if (slotImage != null)
        {
            slotImage.color = slotIndex == selectedSlotIndex ? highlightSlotColor : normalSlotColor;
        }
        
        // Play add animation
        if (enableAnimations)
        {
            PlayItemAddAnimation(slotIndex);
        }
        
        // Play sound
        if (!string.IsNullOrEmpty(itemAddSoundId))
        {
            GameEvents.InvokePlaySound(itemAddSoundId);
        }
    }
    
    public void HideItemSlot(int slotIndex)
    {
        if (slotIndex < 0 || slotIndex >= itemSlots.Length) return;
        
        // Hide slot
        itemSlots[slotIndex].SetActive(false);
        
        // Reset slot
        if (itemIcons[slotIndex] != null)
        {
            itemIcons[slotIndex].sprite = null;
            itemIcons[slotIndex].color = emptySlotColor;
        }
        
        if (itemCounts[slotIndex] != null)
        {
            itemCounts[slotIndex].text = "";
            itemCounts[slotIndex].gameObject.SetActive(false);
        }
        
        // Reset slot color
        Image slotImage = itemSlots[slotIndex].GetComponent<Image>();
        if (slotImage != null)
        {
            slotImage.color = emptySlotColor;
        }
    }
    
    public void SelectSlot(int slotIndex)
    {
        // Deselect previous slot
        if (selectedSlotIndex >= 0 && selectedSlotIndex < itemSlots.Length)
        {
            Image prevSlotImage = itemSlots[selectedSlotIndex].GetComponent<Image>();
            if (prevSlotImage != null)
            {
                prevSlotImage.color = normalSlotColor;
            }
        }
        
        // Select new slot
        selectedSlotIndex = slotIndex;
        
        if (slotIndex >= 0 && slotIndex < itemSlots.Length)
        {
            Image slotImage = itemSlots[slotIndex].GetComponent<Image>();
            if (slotImage != null)
            {
                slotImage.color = highlightSlotColor;
            }
            
            // Play select sound
            if (!string.IsNullOrEmpty(itemSelectSoundId))
            {
                GameEvents.InvokePlaySound(itemSelectSoundId);
            }
        }
    }
    
    public void SetInventoryVisible(bool visible)
    {
        isInventoryVisible = visible;
        
        if (inventoryPanel != null)
        {
            inventoryPanel.SetActive(visible);
        }
        
        if (debugMode)
        {
            Debug.Log($"Inventory visibility set to: {visible}");
        }
    }
    
    public void RefreshInventory()
    {
        UpdateInventory();
    }
    
    // Private methods
    private void OnSlotClicked(int slotIndex)
    {
        SelectSlot(slotIndex);
        
        // Handle item selection/use
        if (slotIndex < currentItems.Count)
        {
            var item = currentItems[slotIndex];
            // You can add item use logic here
            if (debugMode)
            {
                Debug.Log($"Item clicked: {item.displayName}");
            }
        }
    }
    
    private void PlayItemAddAnimation(int slotIndex)
    {
        if (activeAnimations.ContainsKey(slotIndex))
        {
            StopCoroutine(activeAnimations[slotIndex]);
        }
        
        activeAnimations[slotIndex] = StartCoroutine(ItemAddAnimationCoroutine(slotIndex));
    }
    
    private System.Collections.IEnumerator ItemAddAnimationCoroutine(int slotIndex)
    {
        if (slotIndex >= itemSlots.Length) yield break;
        
        Transform slotTransform = itemSlots[slotIndex].transform;
        Vector3 originalScale = originalScales.ContainsKey(slotIndex) ? originalScales[slotIndex] : Vector3.one;
        
        // Scale up
        float elapsed = 0f;
        while (elapsed < itemAddAnimationDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / itemAddAnimationDuration;
            float scale = Mathf.Lerp(originalScale.x, itemAddScale.x, t);
            
            slotTransform.localScale = Vector3.one * scale;
            
            yield return null;
        }
        
        // Scale back down
        elapsed = 0f;
        while (elapsed < itemAddAnimationDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / itemAddAnimationDuration;
            float scale = Mathf.Lerp(itemAddScale.x, originalScale.x, t);
            
            slotTransform.localScale = Vector3.one * scale;
            
            yield return null;
        }
        
        slotTransform.localScale = originalScale;
        activeAnimations.Remove(slotIndex);
    }
    
    // Public API
    public void SetShowItemCounts(bool show)
    {
        showItemCounts = show;
        UpdateInventoryDisplay();
    }
    
    public void SetShowItemNames(bool show)
    {
        showItemNames = show;
        UpdateInventoryDisplay();
    }
    
    public void SetEnableAnimations(bool enable)
    {
        enableAnimations = enable;
    }
    
    public void SetMaxVisibleSlots(int maxSlots)
    {
        maxVisibleSlots = maxSlots;
        // Recreate slots if needed
        CreateItemSlots();
    }
    
    // Getters
    public bool IsInventoryVisible() => isInventoryVisible;
    public int GetSelectedSlotIndex() => selectedSlotIndex;
    public List<InventoryItem> GetCurrentItems() => new List<InventoryItem>(currentItems);
    public int GetItemCount() => currentItems.Count;
    public InventoryItem GetSelectedItem()
    {
        if (selectedSlotIndex >= 0 && selectedSlotIndex < currentItems.Count)
        {
            return currentItems[selectedSlotIndex];
        }
        return null;
    }
    
    // Debug
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw inventory debug info
        GUILayout.BeginArea(new Rect(10, Screen.height - 450, 200, 140));
        GUILayout.Label("Inventory UI Debug");
        GUILayout.Label($"Visible: {isInventoryVisible}");
        GUILayout.Label($"Items: {currentItems.Count}");
        GUILayout.Label($"Selected: {selectedSlotIndex}");
        GUILayout.Label($"Max Slots: {maxVisibleSlots}");
        
        if (GUILayout.Button("Update Inventory"))
        {
            UpdateInventory();
        }
        
        if (GUILayout.Button("Toggle Visibility"))
        {
            SetInventoryVisible(!isInventoryVisible);
        }
        
        GUILayout.EndArea();
    }
}

