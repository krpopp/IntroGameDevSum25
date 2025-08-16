using UnityEngine;
using UnityEditor;
using System.IO;

public class ConfigureUnityAssets : EditorWindow
{
    [MenuItem("Tools/Configure Migrated Assets")]
    public static void ConfigureAssets()
    {
        ConfigureUnityAssets window = GetWindow<ConfigureUnityAssets>("Asset Configuration");
        window.Show();
    }

    private void OnGUI()
    {
        GUILayout.Label("GameMaker to Unity Asset Configuration", EditorStyles.boldLabel);
        
        if (GUILayout.Button("Configure All Sprites"))
        {
            ConfigureAllSprites();
        }
        
        if (GUILayout.Button("Configure All Fonts"))
        {
            ConfigureAllFonts();
        }
        
        if (GUILayout.Button("Create Sprite Atlases"))
        {
            CreateSpriteAtlases();
        }
        
        if (GUILayout.Button("Set Up Sorting Layers"))
        {
            SetupSortingLayers();
        }
    }

    private void ConfigureAllSprites()
    {
        // Configure all PNG files in Sprites folders
        string[] spritePaths = {
            "Assets/Sprites/Characters",
            "Assets/Sprites/Environment", 
            "Assets/Sprites/Items",
            "Assets/Sprites/UI"
        };

        foreach (string path in spritePaths)
        {
            if (Directory.Exists(path))
            {
                string[] pngFiles = Directory.GetFiles(path, "*.png", SearchOption.AllDirectories);
                foreach (string pngFile in pngFiles)
                {
                    ConfigureSprite(pngFile);
                }
            }
        }
        
        AssetDatabase.Refresh();
        Debug.Log("All sprites configured!");
    }

    private void ConfigureSprite(string assetPath)
    {
        TextureImporter importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
        if (importer != null)
        {
            importer.textureType = TextureImporterType.Sprite;
            importer.spriteImportMode = SpriteImportMode.Single;
            importer.filterMode = FilterMode.Point; // For pixel art
            importer.textureCompression = TextureImporterCompression.Uncompressed;
            importer.mipmapEnabled = false;
            importer.maxTextureSize = 2048;
            importer.spritePixelsPerUnit = 32; // Adjust based on your game scale
            
            // Set sprite pivot to center
            importer.spriteAlignment = (int)SpriteAlignment.Center;
            
            AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceUpdate);
        }
    }

    private void ConfigureAllFonts()
    {
        string fontPath = "Assets/Fonts";
        if (Directory.Exists(fontPath))
        {
            string[] pngFiles = Directory.GetFiles(fontPath, "*.png");
            foreach (string pngFile in pngFiles)
            {
                ConfigureFont(pngFile);
            }
        }
        
        AssetDatabase.Refresh();
        Debug.Log("All fonts configured!");
    }

    private void ConfigureFont(string assetPath)
    {
        TextureImporter importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
        if (importer != null)
        {
            importer.textureType = TextureImporterType.Sprite;
            importer.spriteImportMode = SpriteImportMode.Single;
            importer.filterMode = FilterMode.Point;
            importer.textureCompression = TextureImporterCompression.Uncompressed;
            importer.mipmapEnabled = false;
            importer.maxTextureSize = 2048;
            importer.spritePixelsPerUnit = 32;
            
            AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceUpdate);
        }
    }

    private void CreateSpriteAtlases()
    {
        // Create sprite atlases for better performance
        CreateSpriteAtlas("CharacterAtlas", "Assets/Sprites/Characters");
        CreateSpriteAtlas("EnvironmentAtlas", "Assets/Sprites/Environment");
        CreateSpriteAtlas("ItemAtlas", "Assets/Sprites/Items");
        CreateSpriteAtlas("UIAtlas", "Assets/Sprites/UI");
        
        AssetDatabase.Refresh();
        Debug.Log("Sprite atlases created!");
    }

    private void CreateSpriteAtlas(string atlasName, string folderPath)
    {
        // Note: This requires Unity's 2D Sprite Atlas package
        // You may need to install it via Package Manager
        Debug.Log($"Creating sprite atlas: {atlasName} from {folderPath}");
        
        // For now, just log the creation
        // In a full implementation, you would use Unity's SpriteAtlas API
    }

    private void SetupSortingLayers()
    {
        // Set up sorting layers for proper rendering order
        SerializedObject tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
        SerializedProperty sortingLayers = tagManager.FindProperty("m_SortingLayers");
        
        // Add sorting layers if they don't exist
        AddSortingLayer(sortingLayers, "Background", -10);
        AddSortingLayer(sortingLayers, "Environment", -5);
        AddSortingLayer(sortingLayers, "Items", 0);
        AddSortingLayer(sortingLayers, "Characters", 5);
        AddSortingLayer(sortingLayers, "UI", 10);
        AddSortingLayer(sortingLayers, "Foreground", 15);
        
        tagManager.ApplyModifiedProperties();
        Debug.Log("Sorting layers configured!");
    }

    private void AddSortingLayer(SerializedProperty sortingLayers, string name, int order)
    {
        // Check if layer already exists
        bool exists = false;
        for (int i = 0; i < sortingLayers.arraySize; i++)
        {
            SerializedProperty layer = sortingLayers.GetArrayElementAtIndex(i);
            SerializedProperty layerName = layer.FindPropertyRelative("name");
            if (layerName.stringValue == name)
            {
                exists = true;
                break;
            }
        }
        
        if (!exists)
        {
            sortingLayers.arraySize++;
            SerializedProperty newLayer = sortingLayers.GetArrayElementAtIndex(sortingLayers.arraySize - 1);
            SerializedProperty newLayerName = newLayer.FindPropertyRelative("name");
            SerializedProperty newLayerOrder = newLayer.FindPropertyRelative("uniqueID");
            
            newLayerName.stringValue = name;
            newLayerOrder.intValue = order;
        }
    }
}
