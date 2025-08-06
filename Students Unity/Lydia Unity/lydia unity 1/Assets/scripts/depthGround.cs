using UnityEngine;

public class depthGround : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
        SpriteRenderer sr = GetComponent<SpriteRenderer>();
        sr.sortingOrder = 100000; 
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
