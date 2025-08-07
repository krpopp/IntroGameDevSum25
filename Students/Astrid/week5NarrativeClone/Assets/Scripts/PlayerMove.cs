using UnityEngine;

public class PlayerMove : MonoBehaviour
{

    //speed for player WASD movement
    public float movementSpeed = 2f;

    public Rigidbody2D rb;
    public Animator animator;

    Vector2 movement;

    //reference to my player's animator component

    void Start()
    {

    }

    // use Update for registrating the input
    void Update()
    {
        // input
        movement.x = Input.GetAxisRaw("Horizontal");
        movement.y = Input.GetAxisRaw("Vertical");

        animator.SetFloat("Horizontal", movement.x);
        animator.SetFloat("Vertical", movement.y);
        animator.SetFloat("Speed", movement.sqrMagnitude);


        // //current x,y,z position of player in the scene
        // Vector3 currentPos = transform.position;
        // //WASD
        // //Time.deltaTime：making the speed slower.
        // if (Input.GetKey(KeyCode.W))
        // {
        //     currentPos.y += Speed * Time.deltaTime;
        // }
        // else if (Input.GetKey(KeyCode.S))
        // {
        //     currentPos.y -= Speed * Time.deltaTime;
        // }
        // if (Input.GetKey(KeyCode.A))
        // {
        //     currentPos.x -= Speed * Time.deltaTime;
        // }
        // else if (Input.GetKey(KeyCode.D))
        // {
        //     currentPos.x += Speed * Time.deltaTime;
        // }

    }

    //FixedUpdate is only called 50 times a second
    void FixedUpdate()
    {
        //Movement
        rb.MovePosition(rb.position + movement * movementSpeed * Time.fixedDeltaTime);

    } 

}
