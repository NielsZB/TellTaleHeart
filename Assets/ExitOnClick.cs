using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExitOnClick : MonoBehaviour
{

    public void ExitGame()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            Debug.Log("QUIT");
            Application.Quit();
        }

    }

}