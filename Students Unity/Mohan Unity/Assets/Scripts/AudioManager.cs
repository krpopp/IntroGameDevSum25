using UnityEngine;
using System.Collections.Generic;

public class AudioManager : MonoBehaviour
{
    [Header("Audio Sources")]
    public AudioSource musicSource;
    public AudioSource sfxSource;
    
    [Header("Sound Effects")]
    public AudioClip keyPickupSound;
    public AudioClip doorOpenSound;
    public AudioClip exitSound;
    public AudioClip talkSound;
    
    private Dictionary<string, AudioClip> soundClips = new Dictionary<string, AudioClip>();
    
    public static AudioManager Instance { get; private set; }
    
    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeAudioManager();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    void InitializeAudioManager()
    {
        soundClips["key"] = keyPickupSound;
        soundClips["door"] = doorOpenSound;
        soundClips["exit"] = exitSound;
        soundClips["talk"] = talkSound;
        
        if (musicSource == null)
        {
            musicSource = gameObject.AddComponent<AudioSource>();
            musicSource.loop = true;
        }
        
        if (sfxSource == null)
        {
            sfxSource = gameObject.AddComponent<AudioSource>();
        }
    }
    
    public void PlaySound(string soundName)
    {
        if (soundClips.ContainsKey(soundName))
        {
            sfxSource.PlayOneShot(soundClips[soundName]);
        }
        else
        {
            Debug.LogWarning($"Sound '{soundName}' not found in AudioManager");
        }
    }
    
    public void PlayMusic(AudioClip musicClip)
    {
        if (musicSource != null && musicClip != null)
        {
            musicSource.clip = musicClip;
            musicSource.Play();
        }
    }
    
    public void StopMusic()
    {
        if (musicSource != null)
        {
            musicSource.Stop();
        }
    }
    
    public void SetMusicVolume(float volume)
    {
        if (musicSource != null)
        {
            musicSource.volume = Mathf.Clamp01(volume);
        }
    }
    
    public void SetSFXVolume(float volume)
    {
        if (sfxSource != null)
        {
            sfxSource.volume = Mathf.Clamp01(volume);
        }
    }
}
