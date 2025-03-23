using UnityEngine.EventSystems;
using UnityEngine;

namespace ButtonsAudio
{
    [RequireComponent(typeof(AudioSource))]
    public class ButtonsAudio : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler
    {
        [SerializeField] private AudioClip _onHover, _onClick;
        private AudioSource _source;

        public void OnPointerClick(PointerEventData eventData)
        {
            if (_onClick != null && _source != null)
            {
                _source.PlayOneShot(_onClick);
            }
        }

        public void OnPointerEnter(PointerEventData eventData)
        {
            OnPointerExit(null);
        }

        public void OnPointerExit(PointerEventData eventData)
        {
            if (_onHover != null && _source != null)
            {
                _source.PlayOneShot(_onHover);
            }
        }

        private void Awake()
        {
            _source = GetComponent<AudioSource>();
            _source.playOnAwake = false;
            _source.Stop();
        }
    }
}