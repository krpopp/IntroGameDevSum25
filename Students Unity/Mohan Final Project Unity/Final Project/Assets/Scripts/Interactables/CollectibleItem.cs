using UnityEngine;

public class CollectibleItem : InteractableBase, ICollectible
{
    [Header("Item Settings")]
    [SerializeField] private ItemData itemData;
    [SerializeField] private string itemId = "";
    [SerializeField] private string displayName = "";
    [SerializeField] private string description = "";
    [SerializeField] private Sprite icon;
    [SerializeField] private Sprite worldSprite;
    
    [Header("Collection Settings")]
    [SerializeField] private bool destroyOnCollect = true;
    [SerializeField] private bool playCollectionAnimation = true;
    [SerializeField] private float collectionAnimationDuration = 1f;
    [SerializeField] private Vector3 collectionAnimationOffset = Vector3.up * 50f;
    
    [Header("Visual Effects")]
    [SerializeField] private GameObject collectionEffect;
    [SerializeField] private bool fadeOutOnCollect = true;
    [SerializeField] private float fadeOutDuration = 0.5f;
    
    [Header("Audio")]
    [SerializeField] private string collectSoundId = "collect";
    [SerializeField] private string collectFailSoundId = "collect_fail";
    
    // Collection state
    private bool isCollected = false;
    private bool isCollecting = false;
    private Vector3 originalPosition;
    private Vector3 originalScale;
    private Color originalColor;
    private SpriteRenderer spriteRenderer;
    
    // ICollectible properties
    public string ItemId => itemId;
    public string DisplayName => displayName;
    public string Description => description;
    public Sprite Icon => icon;
    
    protected override void Awake()
    {
        base.Awake();
        
        // Get components
        spriteRenderer = GetComponent<SpriteRenderer>();
        
        // Store original values
        originalPosition = transform.position;
        originalScale = transform.localScale;
        if (spriteRenderer != null)
        {
            originalColor = spriteRenderer.color;
        }
        
        // Initialize from ItemData if available
        if (itemData != null)
        {
            InitializeFromItemData();
        }
        
        // Set interaction prompt
        if (string.IsNullOrEmpty(interactionPrompt))
        {
            interactionPrompt = $"Press E to collect {displayName}";
        }
    }
    
    private void InitializeFromItemData()
    {
        itemId = itemData.itemId;
        displayName = itemData.displayName;
        description = itemData.description;
        icon = itemData.icon;
        worldSprite = itemData.worldSprite;
        interactionRange = itemData.interactionRange;
        
        // Update sprite if world sprite is available
        if (worldSprite != null && spriteRenderer != null)
        {
            spriteRenderer.sprite = worldSprite;
        }
        
        // Apply tint color
        if (spriteRenderer != null)
        {
            spriteRenderer.color = itemData.tintColor;
            originalColor = itemData.tintColor;
        }
    }
    
    protected override void PerformInteraction(GameObject interactor)
    {
        if (isCollected || isCollecting) return;
        
        // Check if player can collect
        if (!CanCollect(interactor))
        {
            // Play fail sound
            if (!string.IsNullOrEmpty(collectFailSoundId))
            {
                GameEvents.InvokePlaySound(collectFailSoundId);
            }
            
            if (debugMode)
            {
                Debug.Log($"Cannot collect {itemId}: conditions not met");
            }
            return;
        }
        
        // Start collection process
        StartCollection(interactor);
    }
    
    public bool CanCollect(GameObject collector)
    {
        if (isCollected || isCollecting) return false;
        
        // Check if collector has inventory
        var inventory = collector.GetComponent<PlayerInventory>();
        if (inventory == null) return false;
        
        // Check if inventory is full
        if (inventory.IsInventoryFull() && !inventory.HasItem(itemId))
        {
            return false;
        }
        
        // Check item-specific conditions
        if (itemData != null)
        {
            // Check required items
            if (itemData.requiredItems != null && itemData.requiredItems.Length > 0)
            {
                foreach (var requiredItem in itemData.requiredItems)
                {
                    if (!inventory.HasItem(requiredItem))
                    {
                        return false;
                    }
                }
            }
            
            // Check incompatible items
            if (itemData.incompatibleItems != null && itemData.incompatibleItems.Length > 0)
            {
                foreach (var incompatibleItem in itemData.incompatibleItems)
                {
                    if (inventory.HasItem(incompatibleItem))
                    {
                        return false;
                    }
                }
            }
        }
        
        return true;
    }
    
    public void Collect(GameObject collector)
    {
        if (!CanCollect(collector)) return;
        
        StartCollection(collector);
    }
    
    public void OnCollectStart(GameObject collector)
    {
        // This is called when collection starts
        isCollecting = true;
        
        if (debugMode)
        {
            Debug.Log($"Started collecting {itemId}");
        }
    }
    
    public void OnCollectComplete(GameObject collector)
    {
        // This is called when collection is complete
        isCollected = true;
        
        // Add item to inventory
        var inventory = collector.GetComponent<PlayerInventory>();
        if (inventory != null)
        {
            inventory.AddItem(itemId, displayName, icon);
        }
        
        // Emit collection event
        GameEvents.InvokeItemCollected(itemId);
        
        if (debugMode)
        {
            Debug.Log($"Completed collecting {itemId}");
        }
    }
    
    private void StartCollection(GameObject collector)
    {
        if (isCollecting) return;
        
        isCollecting = true;
        
        // Call collection start
        OnCollectStart(collector);
        
        // Play collection sound
        if (!string.IsNullOrEmpty(collectSoundId))
        {
            GameEvents.InvokePlaySound(collectSoundId);
        }
        
        // Start collection animation
        if (playCollectionAnimation)
        {
            StartCoroutine(CollectionAnimationCoroutine(collector));
        }
        else
        {
            // Immediate collection
            CompleteCollection(collector);
        }
    }
    
    private void CompleteCollection(GameObject collector)
    {
        // Call collection complete
        OnCollectComplete(collector);
        
        // Play collection effect
        if (collectionEffect != null)
        {
            Instantiate(collectionEffect, transform.position, transform.rotation);
        }
        
        // Handle post-collection
        if (destroyOnCollect)
        {
            if (fadeOutOnCollect)
            {
                StartCoroutine(FadeOutCoroutine());
            }
            else
            {
                Destroy(gameObject);
            }
        }
        else
        {
            // Reset for potential re-collection
            isCollected = false;
            isCollecting = false;
        }
    }
    
    private System.Collections.IEnumerator CollectionAnimationCoroutine(GameObject collector)
    {
        float elapsed = 0f;
        Vector3 startPosition = transform.position;
        Vector3 endPosition = startPosition + collectionAnimationOffset;
        Vector3 startScale = transform.localScale;
        Vector3 endScale = startScale * 1.2f;
        
        // Animate collection
        while (elapsed < collectionAnimationDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / collectionAnimationDuration;
            float easeT = Mathf.Sin(t * Mathf.PI * 0.5f); // Ease out
            
            transform.position = Vector3.Lerp(startPosition, endPosition, easeT);
            transform.localScale = Vector3.Lerp(startScale, endScale, easeT);
            
            yield return null;
        }
        
        // Complete collection
        CompleteCollection(collector);
    }
    
    private System.Collections.IEnumerator FadeOutCoroutine()
    {
        if (spriteRenderer == null) yield break;
        
        float elapsed = 0f;
        Color startColor = spriteRenderer.color;
        Color endColor = new Color(startColor.r, startColor.g, startColor.b, 0f);
        
        while (elapsed < fadeOutDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / fadeOutDuration;
            
            spriteRenderer.color = Color.Lerp(startColor, endColor, t);
            
            yield return null;
        }
        
        Destroy(gameObject);
    }
    
    // Public API
    public void SetItemData(ItemData data)
    {
        itemData = data;
        InitializeFromItemData();
    }
    
    public void SetItemId(string id)
    {
        itemId = id;
    }
    
    public void SetDisplayName(string name)
    {
        displayName = name;
        if (string.IsNullOrEmpty(interactionPrompt))
        {
            interactionPrompt = $"Press E to collect {displayName}";
        }
    }
    
    public void SetIcon(Sprite newIcon)
    {
        icon = newIcon;
    }
    
    public void SetWorldSprite(Sprite sprite)
    {
        worldSprite = sprite;
        if (spriteRenderer != null && sprite != null)
        {
            spriteRenderer.sprite = sprite;
        }
    }
    
    public void SetDestroyOnCollect(bool destroy)
    {
        destroyOnCollect = destroy;
    }
    
    public void SetPlayCollectionAnimation(bool play)
    {
        playCollectionAnimation = play;
    }
    
    // Getters
    public bool IsCollected() => isCollected;
    public bool IsCollecting() => isCollecting;
    public ItemData GetItemData() => itemData;
    
    // Debug
    protected override void OnDrawGizmosSelected()
    {
        base.OnDrawGizmosSelected();
        
        // Draw collection animation path
        if (playCollectionAnimation)
        {
            Gizmos.color = Color.cyan;
            Gizmos.DrawLine(transform.position, transform.position + collectionAnimationOffset);
            Gizmos.DrawWireSphere(transform.position + collectionAnimationOffset, 10f);
        }
    }
    
    protected override void OnValidate()
    {
        base.OnValidate();
        
        // Ensure positive values
        collectionAnimationDuration = Mathf.Max(0f, collectionAnimationDuration);
        fadeOutDuration = Mathf.Max(0f, fadeOutDuration);
    }
}

