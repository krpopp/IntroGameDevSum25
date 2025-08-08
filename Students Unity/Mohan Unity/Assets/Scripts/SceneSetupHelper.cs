using UnityEngine;
using UnityEngine.UI;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class SceneSetupHelper : MonoBehaviour
{
    [Header("Scene Setup")]
    public string sceneName = "StartScene";
    public bool setupUI = true;
    public bool setupCamera = true;
    
    [Header("UI Settings")]
    public string gameTitle = "Adventure Quest";
    public Color backgroundColor = Color.black;
    public Color titleColor = Color.white;
    public Color startTextColor = Color.yellow;
    
    void Start()
    {
        if (setupUI)
        {
            SetupUI();
        }
        
        if (setupCamera)
        {
            SetupCamera();
        }
    }
    
    void SetupUI()
    {
        Canvas canvas = FindFirstObjectByType<Canvas>();
        if (canvas == null)
        {
            GameObject canvasObj = new GameObject("Canvas");
            canvas = canvasObj.AddComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            canvas.sortingOrder = 100;
            
            CanvasScaler scaler = canvasObj.AddComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1920, 1080);
            
            canvasObj.AddComponent<GraphicRaycaster>();
        }
        
        GameObject mainMenuPanel = new GameObject("MainMenuPanel");
        mainMenuPanel.transform.SetParent(canvas.transform, false);
        
        Image backgroundImage = mainMenuPanel.AddComponent<Image>();
        backgroundImage.color = backgroundColor;
        RectTransform bgRect = backgroundImage.rectTransform;
        bgRect.anchorMin = Vector2.zero;
        bgRect.anchorMax = Vector2.one;
        bgRect.offsetMin = Vector2.zero;
        bgRect.offsetMax = Vector2.zero;
        
        
        
        GameObject instructionsObj = new GameObject("InstructionsText");
        instructionsObj.transform.SetParent(mainMenuPanel.transform, false);
        Text instructionsText = instructionsObj.AddComponent<Text>();
        instructionsText.text = "Use WASD to move, E to interact";
        instructionsText.color = Color.gray;
        instructionsText.fontSize = 24;
        instructionsText.alignment = TextAnchor.MiddleCenter;
        instructionsText.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        
        RectTransform instructionsRect = instructionsText.rectTransform;
        instructionsRect.anchorMin = new Vector2(0.1f, 0.1f);
        instructionsRect.anchorMax = new Vector2(0.9f, 0.25f);
        instructionsRect.offsetMin = Vector2.zero;
        instructionsRect.offsetMax = Vector2.zero;
        
        GameObject startButtonObj = new GameObject("StartButton");
        startButtonObj.transform.SetParent(mainMenuPanel.transform, false);
        Button startButton = startButtonObj.AddComponent<Button>();
        Image buttonImage = startButtonObj.AddComponent<Image>();
        buttonImage.color = new Color(0.2f, 0.2f, 0.2f, 0.8f);
        
        Text buttonText = startButtonObj.AddComponent<Text>();
        buttonText.text = "START";
        buttonText.color = Color.white;
        buttonText.fontSize = 28;
        buttonText.alignment = TextAnchor.MiddleCenter;
        buttonText.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        
        RectTransform buttonRect = startButtonObj.GetComponent<RectTransform>();
        buttonRect.anchorMin = new Vector2(0.35f, 0.15f);
        buttonRect.anchorMax = new Vector2(0.65f, 0.25f);
        buttonRect.offsetMin = Vector2.zero;
        buttonRect.offsetMax = Vector2.zero;
        
        GameObject quitButtonObj = new GameObject("QuitButton");
        quitButtonObj.transform.SetParent(mainMenuPanel.transform, false);
        Button quitButton = quitButtonObj.AddComponent<Button>();
        Image quitButtonImage = quitButtonObj.AddComponent<Image>();
        quitButtonImage.color = new Color(0.2f, 0.2f, 0.2f, 0.8f);
        
        Text quitButtonText = quitButtonObj.AddComponent<Text>();
        quitButtonText.text = "QUIT";
        quitButtonText.color = Color.white;
        quitButtonText.fontSize = 28;
        quitButtonText.alignment = TextAnchor.MiddleCenter;
        quitButtonText.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        
        RectTransform quitButtonRect = quitButtonObj.GetComponent<RectTransform>();
        quitButtonRect.anchorMin = new Vector2(0.35f, 0.05f);
        quitButtonRect.anchorMax = new Vector2(0.65f, 0.15f);
        quitButtonRect.offsetMin = Vector2.zero;
        quitButtonRect.offsetMax = Vector2.zero;
        
        GameObject loadingPanel = new GameObject("LoadingPanel");
        loadingPanel.transform.SetParent(canvas.transform, false);
        loadingPanel.SetActive(false);
        
        Image loadingBg = loadingPanel.AddComponent<Image>();
        loadingBg.color = new Color(0, 0, 0, 0.8f);
        RectTransform loadingRect = loadingBg.rectTransform;
        loadingRect.anchorMin = Vector2.zero;
        loadingRect.anchorMax = Vector2.one;
        loadingRect.offsetMin = Vector2.zero;
        loadingRect.offsetMax = Vector2.zero;
        
        GameObject loadingTextObj = new GameObject("LoadingText");
        loadingTextObj.transform.SetParent(loadingPanel.transform, false);
        Text loadingText = loadingTextObj.AddComponent<Text>();
        loadingText.text = "Loading...";
        loadingText.color = Color.white;
        loadingText.fontSize = 48;
        loadingText.alignment = TextAnchor.MiddleCenter;
        loadingText.font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        
        RectTransform loadingTextRect = loadingText.rectTransform;
        loadingTextRect.anchorMin = new Vector2(0.1f, 0.4f);
        loadingTextRect.anchorMax = new Vector2(0.9f, 0.6f);
        loadingTextRect.offsetMin = Vector2.zero;
        loadingTextRect.offsetMax = Vector2.zero;
        
        GameObject controllerObj = new GameObject("OpeningController");
        OpeningScreen controller = controllerObj.AddComponent<OpeningScreen>();
        
        
    }
    
    void SetupCamera()
    {
        Camera mainCamera = Camera.main;
        if (mainCamera == null)
        {
            GameObject cameraObj = new GameObject("Main Camera");
            mainCamera = cameraObj.AddComponent<Camera>();
            cameraObj.tag = "MainCamera";
        }
        
        mainCamera.backgroundColor = backgroundColor;
        mainCamera.clearFlags = CameraClearFlags.SolidColor;
        mainCamera.orthographic = true;
        mainCamera.orthographicSize = 5f;
        
    }
    
    #if UNITY_EDITOR
    [MenuItem("Tools/Setup Opening Scene")]
    public static void SetupOpeningSceneFromMenu()
    {
        SceneSetupHelper helper = FindFirstObjectByType<SceneSetupHelper>();
        if (helper == null)
        {
            GameObject helperObj = new GameObject("SceneSetupHelper");
            helper = helperObj.AddComponent<SceneSetupHelper>();
        }
        
        helper.SetupUI();
        helper.SetupCamera();
        
    }
    #endif
}
