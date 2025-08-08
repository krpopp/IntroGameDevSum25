using UnityEngine;

public class SpriteQualityFixer : MonoBehaviour
{
    [Header("Sprite Quality Settings")]
    public bool fixSpriteQualityOnStart = true;
    public FilterMode spriteFilterMode = FilterMode.Point;
    public TextureWrapMode spriteWrapMode = TextureWrapMode.Clamp;
    
    void Start()
    {
        if (fixSpriteQualityOnStart)
        {
            FixSpriteQuality();
        }
    }
    
    void FixSpriteQuality()
    {
        SpriteRenderer[] spriteRenderers = FindObjectsByType<SpriteRenderer>(FindObjectsSortMode.None);
        
        foreach (SpriteRenderer renderer in spriteRenderers)
        {
            if (renderer.sprite != null && renderer.sprite.texture != null)
            {
                renderer.sprite.texture.filterMode = spriteFilterMode;
                renderer.sprite.texture.wrapMode = spriteWrapMode;
            }
        }
        
    }
    
    [ContextMenu("Fix Sprite Quality Now")]
    void FixSpriteQualityNow()
    {
        FixSpriteQuality();
    }
}

