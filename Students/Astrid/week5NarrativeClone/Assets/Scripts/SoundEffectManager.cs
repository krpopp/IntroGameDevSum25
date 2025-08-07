using System;
using UnityEngine;

public class SoundEffectManager : MonoBehaviour
{
    // [SerializeField] AudioSource musicSource;
    [SerializeField] AudioSource SFXSource;
    [Header("---------------Audio Clips--------------")]

    public AudioClip dialogue;
    public AudioClip key;
    public AudioClip exit;
    public AudioClip door;

    public void PlaySFX(AudioClip clip)
    {
        SFXSource.PlayOneShot(clip);
    }
}
