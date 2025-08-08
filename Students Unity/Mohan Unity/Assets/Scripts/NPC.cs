using UnityEngine;

public class NPC : MonoBehaviour
{
    [Header("NPC Settings")]
    public string npcType = "orange";

    [Header("Head Anchor")]
    [Tooltip("Name of the child transform used by DialogueSystem for placement")] 
    public string headAnchorName = "HeadAnchor";
    [Tooltip("If true, a head anchor will be created/updated automatically at the sprite top")] 
    public bool autoCreateHeadAnchor = true;
    [Tooltip("Additional world-space Y offset above the sprite's top for the anchor")] 
    public float extraYOffset = 0.0f;

    private SpriteRenderer spriteRenderer;

    void Awake()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        if (autoCreateHeadAnchor)
        {
            CreateOrUpdateHeadAnchor();
        }
    }

    void Reset()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
    }

    void OnValidate()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        if (autoCreateHeadAnchor)
        {
            CreateOrUpdateHeadAnchor();
        }
    }

    private void CreateOrUpdateHeadAnchor()
    {
        if (spriteRenderer == null || spriteRenderer.sprite == null)
            return;

        Transform anchor = FindChildRecursive(transform, headAnchorName);
        if (anchor == null)
        {
            GameObject go = new GameObject(headAnchorName);
            anchor = go.transform;
            anchor.SetParent(transform);
        }

        Bounds worldBounds = spriteRenderer.bounds;
        Vector3 worldTop = new Vector3(worldBounds.center.x, worldBounds.max.y + extraYOffset, transform.position.z);

        anchor.position = worldTop;
        anchor.rotation = Quaternion.identity;
        anchor.localScale = Vector3.one;
    }

    private static Transform FindChildRecursive(Transform root, string childName)
    {
        if (root == null) return null;
        for (int i = 0; i < root.childCount; i++)
        {
            Transform c = root.GetChild(i);
            if (c.name == childName) return c;
            Transform nested = FindChildRecursive(c, childName);
            if (nested != null) return nested;
        }
        return null;
    }

    void OnDrawGizmosSelected()
    {
        if (!autoCreateHeadAnchor) return;
        Transform anchor = FindChildRecursive(transform, headAnchorName);
        if (anchor == null) return;
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireSphere(anchor.position, 0.05f);
    }
}

