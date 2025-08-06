using UnityEngine;

public class PkayerMove : MonoBehaviour
{
    public float speed;
    
    private Animator animator;


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("this is running");
        if (Input.GetKeyDown(KeyCode.S))
        {
            animator.SetInteger("Direction", 0);
        }

        if (Input.GetKeyDown(KeyCode.W))
        {
            animator.SetInteger("Direction", 1);
        }

        if (Input.GetKeyDown(KeyCode.A))
        {
            animator.SetInteger("Direction", 2);
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            animator.SetInteger("Direction", 3);
        }
        if (!Input.GetKey(KeyCode.W) && !Input.GetKey(KeyCode.A) && !Input.GetKey(KeyCode.S) && !Input.GetKey(KeyCode.D))
        {
            animator.SetBool("moving", false);
        }
        else
        {
            animator.SetBool("moving", true);
        }
        Vector3 currentPos = transform.position;

        if (Input.GetKey(KeyCode.W))
        {
            currentPos.y += speed * Time.deltaTime;
            //Debug.Log("key pressed");   
        }
        if (Input.GetKey(KeyCode.A))
        {
            currentPos.x -= speed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.S))
        {
            currentPos.y -= speed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.D))
        {
            currentPos.x += speed * Time.deltaTime;
        }
        transform.position = currentPos;
    }
    
    
    void LateUpdate()
    {
        
        SpriteRenderer sr = GetComponent<SpriteRenderer>();
        sr.sortingOrder = -(int)(transform.position.y * 100); 
    }



    
}
