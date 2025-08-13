using UnityEngine;
using TMPro;

public class BouncePlayer : MonoBehaviour
{

    //set up reference to my player's rigidbody
    public Rigidbody2D myBody;

    //how much force to add when bouncing
    public float bounceForce;
    //how much gravity to add
    public float gravity;

    //keys to control left/right movement
    public KeyCode leftKey, rightKey;

    //how much force to add with the keys
    public float horizontalForce;

    //booleans for managing horizontal movement
    bool goLeft, goRight;

    //reference to player's particle system component
    public ParticleSystem bounceParticles;

    //reference to score UI text
    public TMP_Text scoreText;

    //number to track current score of player
    int score;

    //public sets the scope of that variable (making it accessible to other classes)
    //but i'm just using it to make that variable editable in the inspector!

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        //set the score to 0 at first
        score = 0;
        //set the score UI text to the current score
        //since that variable is a int we need to change it to a string
        scoreText.text = score.ToString();
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
        myBody.linearVelocityY -= gravity;
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
        //and we're higher than the platform
        //set our bounce force to the velocity
        if (transform.position.y >=
            collision.gameObject.transform.position.y &&
            collision.gameObject.CompareTag("Platform"))
        {
            BounceEffects(collision.gameObject);
            myBody.linearVelocityY = bounceForce;
            //myBody.AddForce(new Vector2(0, bounceForce));
        }
    }

    //various effects for when bouncing on a burger
    void BounceEffects(GameObject hitObj)
    {
        //add one to the score
        score += 1;
        //set the UI to reflect the new score
        scoreText.text = score.ToString();
        //get the animator component on the burger we just hit
        hitObj.GetComponent<Animator>().SetTrigger("jiggle");
        //play our bouncy particles
        bounceParticles.Play();
    }
}
