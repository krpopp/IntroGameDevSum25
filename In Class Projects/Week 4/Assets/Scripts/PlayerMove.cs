using UnityEngine;

public class PlayerMove : MonoBehaviour
{

    //speed for player WASD movement
    public float speed;

    //reference to my player's animator component
    Animator myAnim;
    SpriteRenderer mySpriteRend;
    public Rigidbody2D myBody;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        //set my reference to my animator component
        myAnim = GetComponent<Animator>();
        mySpriteRend = GetComponent<SpriteRenderer>();

        Debug.Log(mySpriteRend.sprite);
    }

    // Update is called once per frame
    void Update()
    {
        //current x,y,z position of player in the scene
        Vector3 currentPos = transform.position;
        //if i press WASD, change the current position values
        //multiplying by deltaTime makes my movement frame independent
        if (Input.GetKey(KeyCode.W))
        {
            currentPos.y += speed * Time.deltaTime;
        }
        else if (Input.GetKey(KeyCode.S))
        {
            currentPos.y -= speed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.A))
        {
            currentPos.x -= speed * Time.deltaTime;
        }
        else if (Input.GetKey(KeyCode.D))
        {
            currentPos.x += speed * Time.deltaTime;
        }
        //if my object's position is different from my currentPos variable
        //(which changes based on input)
        if (transform.position != currentPos)
        {
            //set my position to the new currentPos
            //transform.position = currentPos;
            myBody.MovePosition(currentPos);
            //trigger my walking animation
            myAnim.SetBool("isWalking", true);
        }
        else
        {
            //turn off my walking animation
            myAnim.SetBool("isWalking", false);
        }
    }
}
