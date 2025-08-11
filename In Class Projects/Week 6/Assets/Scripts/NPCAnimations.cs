using Unity.VisualScripting;
using UnityEngine;

public class NPCAnimations : MonoBehaviour
{

    Animator myAnim;

    void Start()
    {
        myAnim = GetComponent<Animator>();
    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.transform.position.y < transform.position.y)
        {
            myAnim.SetTrigger("doWag"); 
        }
        Debug.Log("hi!");
    }
}
