using System.Collections;
using UnityEngine;

public class LevelUpCanvas : MonoBehaviour
{
    static readonly int Show_AnimatorProperty = Animator.StringToHash("Shown");
    
    [SerializeField] private AdsCanvas _ads;
    [SerializeField] private Animator _windowAnimator;
    
    [Space(20)]
    [SerializeField] private AudioSource _canvasSource;
    [SerializeField] private AudioClip _showSound, _hideSound;
    
    [Space(20)]
    [SerializeField] private TMPro.TMP_Text _currentLevelLabel;
    [SerializeField] private string _levelFormat = "- Level {0} -";
    
    [Space(20)]
    [SerializeField] private GameObject _claimTurnable;
    [SerializeField] private float _claimTimer = 3f;
    
    [Space(20)]
    [SerializeField] private int _currentLevel = 0;
    private bool _adsShow;
    private Coroutine _claimUsualRewardRoutine;
    
    public void Button_ShowLevelUpCanvas()
    {
        _currentLevel++;
        _currentLevelLabel.text = string.Format(_levelFormat, _currentLevel);
        _claimTurnable.SetActive(false);
        _windowAnimator.SetBool(Show_AnimatorProperty, true);
        if (_canvasSource != null && _showSound != null)
        {
            _canvasSource.PlayOneShot(_showSound);
        }
        _adsShow = false;
        StopClaimTimer();
    }
    
    private void StopClaimTimer()
    {
        if (_claimUsualRewardRoutine != null)
        {
            StopCoroutine(_claimUsualRewardRoutine);
            _claimUsualRewardRoutine = null;
        }
    }
    
    public void Animator_RegisterWindowShown()
    {
        StopClaimTimer();
        _claimUsualRewardRoutine = StartCoroutine(ClaimUsualRewardRoutine());
    }
    
    private IEnumerator ClaimUsualRewardRoutine()
    {
        float timer = 0;
        var wait = new WaitForFixedUpdate();
        while(timer < _claimTimer)
        {
            while(_adsShow) yield return wait;
            timer += Time.fixedDeltaTime;
            yield return wait;
        }
        _claimTurnable.SetActive(true);
        StopClaimTimer();
    }
    
    public void Button_ClaimUsualReward()
    {
        Debug.Log("Claimed usual reward.");
        HideWindowAnimated();
    }
    
    public void Button_Claim2XReward()
    {
        _adsShow = true;
        _ads.Show(AfterWatchAd);
        
        void AfterWatchAd()
        {
            _adsShow = false;
            Debug.Log("Claimed 2X reward.");
            HideWindowAnimated();
        }
    }
    
    private void HideWindowAnimated()
    {
        if (_canvasSource != null && _hideSound != null)
        {
            _canvasSource.PlayOneShot(_hideSound);
        }
        _windowAnimator.SetBool(Show_AnimatorProperty, false);
    }
}