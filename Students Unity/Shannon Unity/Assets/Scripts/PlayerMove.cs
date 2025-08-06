using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    public float speed;

    private Rigidbody2D rb;
    private Animator myAnim;
    private Vector2 currentPos;

    void Start()
    {
        transform.position = transform.localPosition;
        speed = 0.8f;
        rb = GetComponent<Rigidbody2D>();
        myAnim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        //myAnim.SetBool("isWalking", true);
        currentPos = transform.position;
        if (Input.GetKey(KeyCode.W))
        {
            myAnim.SetBool("isWalking", true);
            myAnim.SetBool("FacingUp", true);
            myAnim.SetBool("FacingDown", false);
            myAnim.SetBool("FacingLeft", false);
            myAnim.SetBool("FacingRight", false);
            currentPos.y += speed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.S)) 
        {
            myAnim.SetBool("isWalking", true);
            myAnim.SetBool("FacingUp", false);
            myAnim.SetBool("FacingDown", true);
            myAnim.SetBool("FacingLeft", false);
            myAnim.SetBool("FacingRight", false);
            currentPos.y -= speed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.A))
        {
            myAnim.SetBool("isWalking", true);
            myAnim.SetBool("FacingUp", false);
            myAnim.SetBool("FacingDown", false);
            myAnim.SetBool("FacingLeft", true);
            myAnim.SetBool("FacingRight", false);
            currentPos.x -= speed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.D)) 
        {
            myAnim.SetBool("isWalking", true);
            myAnim.SetBool("FacingUp", false);
            myAnim.SetBool("FacingDown", false);
            myAnim.SetBool("FacingLeft", false);
            myAnim.SetBool("FacingRight", true);
            currentPos.x += speed * Time.deltaTime;
        }
        if (!Input.GetKey(KeyCode.W) && !Input.GetKey(KeyCode.S) && !Input.GetKey(KeyCode.A) && !Input.GetKey(KeyCode.D)) {
            myAnim.SetBool("isWalking", false);
        }

        transform.position = currentPos;
    }
}
