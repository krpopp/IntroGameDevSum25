using UnityEngine;
using UnityEngine.SceneManagement;

public class StartScreenController : MonoBehaviour
{
    void Update()
    {
        // 检测按下空格键
        if (Input.GetKeyDown(KeyCode.Space))
        {
            // 加载主场景，名字请与你的目标场景一致
            SceneManager.LoadScene("MainScene");
        }
    }
}

