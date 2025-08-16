using UnityEditor;
using UnityEngine;
using UnityEditor.PackageManager;
using UnityEditor.PackageManager.Requests;

public class InstallRequiredPackages
{
    [MenuItem("Tools/Packages/Install All")]
    public static void InstallAllPackages()
    {
        InstallCinemachine();
        InstallTextMeshPro();
        InstallSpriteAtlas();
    }

    [MenuItem("Tools/Packages/Install Cinemachine")] 
    public static void InstallCinemachine()
    {
        Client.Add("com.unity.cinemachine");
        Debug.Log("Requested install: Cinemachine");
    }
    
    [MenuItem("Tools/Packages/Install TextMeshPro")] 
    public static void InstallTextMeshPro()
    {
        Client.Add("com.unity.textmeshpro");
        Debug.Log("Requested install: TextMeshPro");
    }
    
    [MenuItem("Tools/Packages/Install 2D Sprite Atlas")] 
    public static void InstallSpriteAtlas()
    {
        Client.Add("com.unity.2d.sprite");
        Debug.Log("Requested install: 2D Sprite Atlas");
    }
}
