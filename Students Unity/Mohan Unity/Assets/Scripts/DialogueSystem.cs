using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Serialization;

public class DialogueSystem : MonoBehaviour
{
    [Header("UI References")]
    public GameObject dialogueBox;
    public Text dialogueText;
    public Canvas canvas;
    [Tooltip("Sorting order for the dialogue canvas so it renders above everything")] public int uiSortingOrder = 1000;

    [Header("Dialogue Settings")]
    public float boxWidth = 570f;
    public float boxHeight = 150f;
    public float screenMargin = 10f;
    [FormerlySerializedAs("gapAboveHeadPx")]
    [Tooltip("Pixel gap between NPC head and the bottom edge of the textbox")] public float gapAboveHeadPixels = 8f;
    [Tooltip("Optional child transform to follow for precise placement")] public string anchorChildName = "HeadAnchor";

    private bool isVisible;
    private Transform currentNPC;
    private Transform anchorTransform;
    private RectTransform dialogueRect;

    void Start()
    {
        isVisible = false;
        currentNPC = null;
        if (dialogueBox != null) dialogueBox.SetActive(false);

        if (dialogueBox != null && dialogueRect == null)
            dialogueRect = dialogueBox.GetComponent<RectTransform>();
        if (canvas == null && dialogueBox != null)
            canvas = dialogueBox.GetComponentInParent<Canvas>();
        if (canvas == null)
            canvas = GetComponentInParent<Canvas>();

        if (dialogueRect != null)
        {
            dialogueRect.sizeDelta = new Vector2(boxWidth, boxHeight);
            dialogueRect.anchorMin = new Vector2(0.5f, 0.5f);
            dialogueRect.anchorMax = new Vector2(0.5f, 0.5f);
            dialogueRect.pivot = new Vector2(0.5f, 0f);
            dialogueRect.anchoredPosition = Vector2.zero;
        }

        TrySetCanvasSortingOrder();
    }

    void Update()
    {
        if (!isVisible || currentNPC == null) return;
        UpdateDialoguePosition();
    }

    public void ShowDialogue(Transform npc, string text)
    {
        if (dialogueBox == null || dialogueText == null) return;
        if (canvas == null) canvas = dialogueBox.GetComponentInParent<Canvas>();

        currentNPC = npc;
        anchorTransform = FindChildByName(npc, anchorChildName);
        dialogueText.text = text;
        if (dialogueRect != null) dialogueRect.sizeDelta = new Vector2(boxWidth, boxHeight);
        UpdateDialoguePosition();

        dialogueBox.SetActive(true);
        isVisible = true;
        AudioManager.Instance?.PlaySound("talk");
    }

    public void HideDialogue()
    {
        if (dialogueBox != null) dialogueBox.SetActive(false);
        isVisible = false;
        currentNPC = null;
        anchorTransform = null;
    }

    void UpdateDialoguePosition()
    {
        if (dialogueRect == null) return;
        Vector3 headWorld;
        if (anchorTransform != null)
        {
            headWorld = anchorTransform.position;
        }
        else if (currentNPC != null)
        {
            var sr = currentNPC.GetComponent<SpriteRenderer>();
            float topY = currentNPC.position.y + (sr != null ? sr.bounds.size.y : 0.5f);
            headWorld = new Vector3(currentNPC.position.x, topY, currentNPC.position.z);
        }
        else return;
        Camera camParam = null;
        if (canvas != null && canvas.renderMode == RenderMode.ScreenSpaceCamera)
            camParam = canvas.worldCamera != null ? canvas.worldCamera : Camera.main;
        Vector3 screen = (camParam != null) ? camParam.WorldToScreenPoint(headWorld) : Camera.main.WorldToScreenPoint(headWorld);
        screen.y += gapAboveHeadPixels;
        float minX = screenMargin + boxWidth * 0.5f;
        float maxX = Screen.width - (screenMargin + boxWidth * 0.5f);
        float minY = screenMargin;
        float maxY = Screen.height - screenMargin - boxHeight;
        screen.x = Mathf.Clamp(screen.x, minX, maxX);
        screen.y = Mathf.Clamp(screen.y, minY, maxY);
        RectTransform canvasRect = canvas != null ? canvas.GetComponent<RectTransform>() : null;
        if (canvasRect == null) return;
        Vector2 local;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(canvasRect, screen, camParam, out local);
        dialogueRect.anchoredPosition = local;
    }

    public bool IsVisible() => isVisible;
    public Transform CurrentNPC => currentNPC;

    private Transform FindChildByName(Transform root, string name)
    {
        if (root == null || string.IsNullOrEmpty(name)) return null;
        for (int i = 0; i < root.childCount; i++)
        {
            var c = root.GetChild(i);
            if (c.name == name) return c;
            var found = FindChildByName(c, name);
            if (found != null) return found;
        }
        return null;
    }

    private void TrySetCanvasSortingOrder()
    {
        if (canvas == null) canvas = GetComponentInParent<Canvas>();
        if (canvas == null) return;
        canvas.overrideSorting = true;
        canvas.sortingLayerName = "Default";
        canvas.sortingOrder = uiSortingOrder;
    }
}
