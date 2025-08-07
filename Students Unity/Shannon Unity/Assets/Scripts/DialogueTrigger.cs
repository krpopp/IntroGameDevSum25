using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DialogueTrigger : MonoBehaviour

{
    [SerializeField] public TMP_Text dial;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void SetDialogue(string newDial)
    {
        dial.text = newDial;
    }
}
