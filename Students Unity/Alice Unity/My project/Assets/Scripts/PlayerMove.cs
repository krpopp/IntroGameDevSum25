using UnityEngine;

public class PlayerMove : MonoBehaviour
{
    public float speed;

    public Animator myAnim;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        myAnim = GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 currentPos = transform.position;
        
        float v = Input.GetAxis("Vertical");
        float h = Input.GetAxis("Horizontal");

        transform.Translate(new Vector3(h, v, 0) * Time.deltaTime * speed);

        if (v>0)
        {
            myAnim.SetBool("isWalkingUp", true);

        }else if (v<0)
        {
            myAnim.SetBool("isWalkingDown", true);
        }
        else if (v==0)
        {
            myAnim.SetBool("isWalkingUp", false);
            myAnim.SetBool("isWalkingDown", false);
        }
        if (h > 0)
        {
           
            myAnim.SetBool("isWalkingRight", true);
        }
        else if (h < 0)
        {
            myAnim.SetBool("isWalkingLeft", true);
   
        }
        else if (h == 0)
        {
            myAnim.SetBool("isWalkingRight", false);
            myAnim.SetBool("isWalkingLeft", false);
        }





        // if (Input.GetKey(KeyCode.W))
        // {
        //     currentPos.y += speed * Time.deltaTime;
        //     myAnim.SetBool("isWalkingUp", true);

        // }
        // else if (Input.GetKeyUp(KeyCode.W))
        // {
        //     /// currentPos.y -= speed * Time.deltaTime;
        //     /// 
        //     myAnim.SetBool("isWalkingUp", false);
        // }
        // if (Input.GetKey(KeyCode.A))
        // {
        //     currentPos.x -= speed * Time.deltaTime;
        // }
        // else if (Input.GetKey(KeyCode.D))
        // {
        //     currentPos.x += speed * Time.deltaTime;
        // }
        // transform.position = currentPos;

        // if ((transform.position != currentPos) && (Input.GetKey(KeyCode.S)))
        // {
        //     transform.position = currentPos;
        //     myAnim.SetBool("isWalkingDown", true);
        // }
        // else
        // {
        //     myAnim.SetBool("isWalkingDown", false);
        // }





    }
}
