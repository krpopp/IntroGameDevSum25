using UnityEngine;
using UnityEngine.UI;

public class DialogueSystem : MonoBehaviour
{
    [Header("UI References")]
    public GameObject dialogueBox;
    public Text dialogueText;
    public Canvas canvas;
    
    [Header("Dialogue Settings")]
    public float boxWidth = 570f;
    public float boxHeight = 150f;
    public float padding = 15f;
    public float screenMargin = 10f;
    public float npcOffsetY = 80f;
    
    private bool isVisible = false;
    private Transform currentNPC;
    private string currentText = "";
    private RectTransform dialogueRect;
    private Image dialogueImage;
    
    void Start()
    {
        isVisible = false;
        currentNPC = null;
        currentText = "";
        if (dialogueBox != null)
        {
            dialogueBox.SetActive(false);
        }

        if (dialogueBox != null && dialogueRect == null)
            dialogueRect = dialogueBox.GetComponent<RectTransform>();

        if (canvas == null && dialogueBox != null)
            canvas = dialogueBox.GetComponentInParent<Canvas>();
        if (canvas == null)
            canvas = GetComponentInParent<Canvas>();
        
        if (canvas != null)
        {
            canvas.renderMode = RenderMode.ScreenSpaceCamera;
            
            if (canvas.worldCamera == null)
            {
                canvas.worldCamera = Camera.main;
                Debug.Log("DIALOGUE: Assigned Main Camera to Canvas");
            }
            
            if (canvas.worldCamera == null)
            {
                Debug.LogError("DialogueSystem: No camera found! Canvas needs a camera for proper positioning.");
            }
            else
            {
                Debug.Log($"DIALOGUE: Canvas render mode: {canvas.renderMode}, Camera: {canvas.worldCamera.name}");
            }
            
            if (!canvas.gameObject.activeInHierarchy)
            {
                Debug.LogWarning("DIALOGUE: Canvas is not active! This might cause issues.");
            }
        }
        
        if (dialogueBox != null)
        {
            dialogueImage = dialogueBox.GetComponent<Image>();
            if (dialogueImage != null)
            {
                dialogueImage.color = new Color(0, 0, 0, 1);
            }
        }
        
        if (dialogueRect != null)
        {
            dialogueRect.sizeDelta = new Vector2(boxWidth, boxHeight);
            
            dialogueRect.anchorMin = new Vector2(0.5f, 0.5f);
            dialogueRect.anchorMax = new Vector2(0.5f, 0.5f);
            dialogueRect.pivot = new Vector2(0.5f, 0.5f);
            
            dialogueRect.anchoredPosition = Vector2.zero;
        }
    }
    
    void Update()
    {
        if (isVisible && currentNPC != null)
        {
            UpdateDialoguePosition();
        }
    }
    
    public void ShowDialogue(Transform npc, string text)
    {
        if (dialogueBox == null || dialogueText == null)
        {
            Debug.LogError("DialogueSystem: Missing dialogueBox or dialogueText reference.");
            return;
        }
        if (canvas == null)
        {
            canvas = dialogueBox.GetComponentInParent<Canvas>();
            if (canvas == null) canvas = GetComponentInParent<Canvas>();
        }

        currentNPC = npc;
        currentText = text;
        dialogueText.text = text;
        
        if (dialogueRect != null)
            dialogueRect.sizeDelta = new Vector2(boxWidth, boxHeight);
        
        dialogueBox.SetActive(true);
        isVisible = true;
        
        Debug.Log($"DIALOGUE: Showing textbox for NPC '{npc?.name}' with text: '{text}'");
        Debug.Log($"DIALOGUE: DialogueBox active: {dialogueBox.activeInHierarchy}, DialogueText active: {dialogueText.gameObject.activeInHierarchy}");
        Debug.Log($"DIALOGUE: Textbox should now be visible on screen");
        AudioManager.Instance?.PlaySound("talk");
    }
    
    public void HideDialogue()
    {
        if (dialogueBox != null)
            dialogueBox.SetActive(false);
        isVisible = false;
        currentNPC = null;
        currentText = "";
        Debug.Log("DIALOGUE: Hiding textbox");
    }
    
    void UpdateDialoguePosition()
    {
        if (currentNPC == null || dialogueRect == null) return;
        
        Camera camera = Camera.main;
        if (camera == null) return;
        
        Vector3 screenPos = camera.WorldToScreenPoint(currentNPC.position);
        
        float npcHeight = 32f;
        var spriteRenderer = currentNPC.GetComponent<SpriteRenderer>();
        if (spriteRenderer != null && spriteRenderer.sprite != null)
        {
            float worldHeight = spriteRenderer.bounds.size.y;
            Vector3 topWorld = currentNPC.position + Vector3.up * worldHeight;
            Vector3 topScreen = camera.WorldToScreenPoint(topWorld);
            npcHeight = Mathf.Abs(topScreen.y - screenPos.y);
        }
        
        float boxX = screenPos.x - (boxWidth / 2);
        float boxY = screenPos.y + npcHeight + npcOffsetY;
        
        boxX = Mathf.Clamp(boxX, screenMargin, Screen.width - boxWidth - screenMargin);
        boxY = Mathf.Clamp(boxY, screenMargin, Screen.height - boxHeight - screenMargin);
        
        dialogueRect.position = new Vector2(boxX + boxWidth/2, boxY + boxHeight/2);
        
        Debug.Log($"DIALOGUE: Positioned textbox at screen position ({boxX + boxWidth/2}, {boxY + boxHeight/2}) (NPC world pos: {currentNPC.position})");
        Debug.Log($"DIALOGUE: Screen bounds: {Screen.width}x{Screen.height}, Textbox size: {boxWidth}x{boxHeight}");
        
        if (boxX + boxWidth/2 < 0 || boxX + boxWidth/2 > Screen.width || boxY + boxHeight/2 < 0 || boxY + boxHeight/2 > Screen.height)
        {
            Debug.LogWarning($"DIALOGUE: Textbox position ({boxX + boxWidth/2}, {boxY + boxHeight/2}) is outside screen bounds!");
        }
    }
    
    public bool IsVisible()
    {
        return isVisible;
    }
}
