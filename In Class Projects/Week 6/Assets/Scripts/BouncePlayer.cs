using UnityEngine;

public class BouncePlayer : MonoBehaviour
{

    //set up reference to my player's rigidbody
    public Rigidbody2D myBody;

    //how much force to add when bouncing
    public float bounceForce;

    //keys to control left/right movement
    public KeyCode leftKey, rightKey;

    //how much force to add with the keys
    public float horizontalForce;

    //booleans for managing horizontal movement
    bool goLeft, goRight;

    //public sets the scope of that variable (making it accessible to other classes)
    //but i'm just using it to make that variable editable in the inspector!

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        //myBody = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        //reset our movement booleans
        goLeft = false;
        goRight = false;

        //if a key is pressed
        if (Input.GetKey(leftKey))
        {
            //set the movement booleans
            goLeft = true;
        }
        if (Input.GetKey(rightKey))
        {
            goRight = true;
        }
    }

    //fixed update is where physics calculations are handled in the execution order
    void FixedUpdate()
    {
        //slow down the player's horizontal velocity
        myBody.linearVelocityX *= 0.9f;

        //depending on which key we pressed
        //add force in the respective direction
        if (goLeft)
        {
            myBody.AddForce(new Vector2(-horizontalForce, 0));
        }
        if (goRight)
        {
            myBody.AddForce(new Vector2(horizontalForce, 0));
        }
    }

    //runs when a collision occurs on this game object
    void OnCollisionEnter2D(Collision2D collision)
    {
        //if the object we collided with is tagged 'Platform'
        //add our bounce force to the velocity
        if (collision.gameObject.CompareTag("Platform"))
        {
            myBody.AddForce(new Vector2(0, bounceForce));
        }
    }
}
