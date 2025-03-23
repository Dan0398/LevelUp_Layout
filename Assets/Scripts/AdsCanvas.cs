using System.Collections;
using UnityEngine;

public class AdsCanvas : MonoBehaviour
{
    static readonly int Show_AnimatorProperty = Animator.StringToHash("Shown");
    
    [SerializeField] private Animator _windowAnimator;
    [SerializeField] private float _adsDelay = 2f;
    private Coroutine _adsShowRoutine;
    
    public void Show(System.Action OnEnd)
    {
        gameObject.SetActive(true);
        _windowAnimator.SetBool(Show_AnimatorProperty, true);
        _adsShowRoutine = StartCoroutine(AdsShowRoutine(OnEnd));
    }
    
    IEnumerator AdsShowRoutine(System.Action OnEnd)
    {
        yield return new WaitForSeconds(_adsDelay);
        _windowAnimator.SetBool(Show_AnimatorProperty, false);
        yield return new WaitForSeconds(.5f);
        OnEnd?.Invoke();
        gameObject.SetActive(false);
        _adsShowRoutine = null;
    }
}