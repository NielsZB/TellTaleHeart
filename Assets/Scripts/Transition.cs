using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Transition : MonoBehaviour
{
    [SerializeField] bool BlendAtStart = true;
    [SerializeField] AnimationCurve blend = new AnimationCurve();
    [SerializeField] float duration = 1f;
    Image panel;
    private void Start()
    {
        panel = GetComponent<Image>();
        if (BlendAtStart)
        {
            StartCoroutine(Transitioning(false));
        }
    }

    public void TransitionToBlack()
    {
        StartCoroutine(Transitioning(true));
    }
    public void TransitionFromBlack()
    {
        StartCoroutine(Transitioning(false));
    }
    IEnumerator Transitioning(bool toBlack)
    {
        float t = 0f;
        panel.enabled = true;
        Color panelColor = panel.color;

        if (!toBlack)
        {
            yield return new WaitForSeconds(0.3f);
        }

        while (t < 1f)
        {
            t += Time.deltaTime / duration;

            if (toBlack)
            {
                panel.color = Color.Lerp(panelColor, Color.black, blend.Evaluate(t));
            }
            else
            {
                panel.color = Color.Lerp(panelColor, Color.clear, blend.Evaluate(t));
            }

            yield return null;
        }

        if (toBlack)
        {
            panel.color = Color.black;
            if (SceneManager.GetActiveScene().buildIndex < SceneManager.sceneCountInBuildSettings - 1)
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
            }
            else
            {
                SceneManager.LoadScene(0);
            }
        }
        else
        {
            panel.color = Color.clear;
            panel.enabled = false;
        }
    }

}
