using UnityEngine;
using System.Collections.Generic;
using UnityEngine.Serialization;

public class PlayerController : MonoBehaviour
{
    [Header("Movement Settings")]
    public float moveSpeed = 1.5f;
    
    [Header("Interaction Settings")]
    [FormerlySerializedAs("responsiveRange")]
    public float interactionRange = 3f;
    
    [Header("Animation")]
    public SpriteRenderer spriteRenderer;
    public Sprite[] playerSprites;
    
    [Header("Depth Settings")]
    [Tooltip("Radius to check for NPC/Bush to decide if player should render behind them")] 
    public float depthCheckRadius = 0.7f;
    [Tooltip("How many order-in-layer steps to go behind a target when player is behind by Y")] 
    public int behindOffset = 1;

    private Vector2 moveInput;
    private List<string> inventory = new List<string>();
    private float animationTimer;
    private int currentFrame;
    private int lastDirectionIndex = 0;
    
    private Rigidbody2D playerRigidbody;

    private struct DepthTarget { public Transform transform; public SpriteRenderer renderer; }
    private readonly List<DepthTarget> depthTargets = new List<DepthTarget>();
    private int defaultPlayerSortingOrder = 2;
    private int lastAppliedSortingOrder = int.MinValue;
    
    void Start()
    {
        playerRigidbody = GetComponent<Rigidbody2D>();
        if (spriteRenderer == null)
            spriteRenderer = GetComponent<SpriteRenderer>();
        
        if (spriteRenderer != null)
        {
            defaultPlayerSortingOrder = spriteRenderer.sortingOrder;
            lastAppliedSortingOrder = defaultPlayerSortingOrder;
        }
        
        BuildDepthTargets();
    }

    void OnEnable()
    {
        BuildDepthTargets();
    }
    
    void Update()
    {
        HandleInput();
        HandleAnimation();
        HandleKeyCollection();
        HandleDialogue();
        HandleDepthSorting();
    }
    
    void FixedUpdate()
    {
        HandleMovement();
    }
    
    void HandleInput()
    {
        moveInput.x = Input.GetAxisRaw("Horizontal");
        moveInput.y = Input.GetAxisRaw("Vertical");
        moveInput.Normalize();
    }
    
    void HandleMovement()
    {
        Vector2 movement = moveInput * moveSpeed;
        playerRigidbody.linearVelocity = movement;
    }
    
    void HandleAnimation()
    {
        int directionIndex = 0;
        if (moveInput.y < 0) directionIndex = 0;
        else if (moveInput.y > 0) directionIndex = 1;
        else if (moveInput.x < 0) directionIndex = 2;
        else if (moveInput.x > 0) directionIndex = 3;

        if (moveInput != Vector2.zero)
        {
            lastDirectionIndex = directionIndex;
            animationTimer += Time.deltaTime;
            if (animationTimer > 0.1f)
            {
                animationTimer = 0f;
                currentFrame = (currentFrame + 1) % 3;
            }
        }
        else
        {
            currentFrame = 0;
            animationTimer = 0f;
        }

        int baseIndex = (moveInput != Vector2.zero ? directionIndex : lastDirectionIndex) * 4;
        int spriteIndex = baseIndex + currentFrame;
        if (playerSprites != null && playerSprites.Length == 16)
            spriteRenderer.sprite = playerSprites[spriteIndex];
    }
    
    void HandleKeyCollection()
    {
        Collider2D[] colliders = Physics2D.OverlapCircleAll(transform.position, 0.5f);
        
        foreach (Collider2D collider in colliders)
        {
            Key key = collider.GetComponent<Key>();
            if (key != null)
            {
                AddItem("key");
                AudioManager.Instance?.PlaySound("key");
                Destroy(key.gameObject);
                break;
            }
        }
    }
    
    void HandleDialogue()
    {
        DialogueSystem dialogueSystem = FindFirstObjectByType<DialogueSystem>();
        if (dialogueSystem == null) return;
        
        NPC[] npcs = FindObjectsByType<NPC>(FindObjectsSortMode.None);
        NPC npcOrange = null;
        NPC npcBrown = null;
        float dOrange = float.MaxValue;
        float dBrown = float.MaxValue;
        foreach (var npc in npcs)
        {
            float d = Vector2.Distance(transform.position, npc.transform.position);
            if (npc.npcType == "orange")
            {
                if (d < dOrange) { dOrange = d; npcOrange = npc; }
            }
            else if (npc.npcType == "brown")
            {
                if (d < dBrown) { dBrown = d; npcBrown = npc; }
            }
        }

        bool showText = false;

        if (npcOrange != null && dOrange < interactionRange)
        {
            showText = true;
            if (Input.GetKeyDown(KeyCode.Space))
            {
                string line = HasItem("key")
                    ? "Great. My friend will tell you how to escape this place."
                    : "The key is some way to the east of here.";
                dialogueSystem.ShowDialogue(npcOrange.transform, line);
            }
        }
        else if (npcBrown != null && dBrown < interactionRange)
        {
            showText = true;
            if (Input.GetKeyDown(KeyCode.Space))
            {
                dialogueSystem.ShowDialogue(npcBrown.transform, "The exit is north of here, hidden behind a tree.");
            }
        }

        if (dialogueSystem.IsVisible() && dialogueSystem.CurrentNPC != null)
        {
            float dActive = Vector2.Distance(transform.position, dialogueSystem.CurrentNPC.position);
            if (dActive > interactionRange)
            {
                dialogueSystem.HideDialogue();
            }
        }
        else if (!showText && dialogueSystem.IsVisible())
        {
            dialogueSystem.HideDialogue();
        }
    }

    void BuildDepthTargets()
    {
        depthTargets.Clear();
        var npcs = FindObjectsByType<NPC>(FindObjectsSortMode.None);
        foreach (var npc in npcs)
        {
            var npcSpriteRenderer = npc.GetComponent<SpriteRenderer>();
            if (npc != null && npcSpriteRenderer != null)
                depthTargets.Add(new DepthTarget { transform = npc.transform, renderer = npcSpriteRenderer });
        }
        var bushes = FindObjectsByType<Bush>(FindObjectsSortMode.None);
        foreach (var bush in bushes)
        {
            var bushSpriteRenderer = bush.GetComponent<SpriteRenderer>();
            if (bush != null && bushSpriteRenderer != null)
                depthTargets.Add(new DepthTarget { transform = bush.transform, renderer = bushSpriteRenderer });
        }
    }

    void HandleDepthSorting()
    {
        if (spriteRenderer == null)
            return;

        float radius = Mathf.Max(0.05f, depthCheckRadius);
        float radiusSquared = radius * radius;
        DepthTarget? closest = null;
        float closestSquaredDistance = float.MaxValue;

        for (int i = 0; i < depthTargets.Count; i++)
        {
            var target = depthTargets[i];
            if (target.transform == null || target.renderer == null)
                continue;

            float squaredDistance = (target.transform.position - transform.position).sqrMagnitude;
            if (squaredDistance < closestSquaredDistance && squaredDistance <= radiusSquared)
            {
                closestSquaredDistance = squaredDistance;
                closest = target;
            }
        }

        int desiredOrder = defaultPlayerSortingOrder;
        if (closest.HasValue)
        {
            var target = closest.Value;
            bool sameLayer = target.renderer.sortingLayerID == spriteRenderer.sortingLayerID;
            if (sameLayer)
            {
                if (transform.position.y > target.transform.position.y)
                {
                    desiredOrder = target.renderer.sortingOrder - Mathf.Abs(behindOffset);
                }
                else
                {
                    desiredOrder = defaultPlayerSortingOrder;
                }
            }
        }

        if (desiredOrder != lastAppliedSortingOrder)
        {
            spriteRenderer.sortingOrder = desiredOrder;
            lastAppliedSortingOrder = desiredOrder;
        }
    }
    
    public bool HasItem(string itemName)
    {
        return inventory.Contains(itemName);
    }
    
    public void AddItem(string itemName)
    {
        inventory.Add(itemName);
    }
    
    public void RemoveItem(string itemName)
    {
        inventory.Remove(itemName);
    }
}
