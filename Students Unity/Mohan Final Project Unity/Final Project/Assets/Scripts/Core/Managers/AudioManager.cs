using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;

[System.Serializable]
public class SoundEffect
{
    public string soundId;
    public AudioClip audioClip;
    [Range(0f, 1f)]
    public float volume = 1f;
    [Range(0.1f, 3f)]
    public float pitch = 1f;
    public bool loop = false;
    public AudioMixerGroup mixerGroup;
}

[System.Serializable]
public class MusicTrack
{
    public string musicId;
    public AudioClip audioClip;
    [Range(0f, 1f)]
    public float volume = 0.7f;
    public bool loop = true;
    public AudioMixerGroup mixerGroup;
}

public class AudioManager : MonoBehaviour
{
    public static AudioManager Instance { get; private set; }
    
    [Header("Audio Configuration")]
    [SerializeField] private AudioMixer audioMixer;
    [SerializeField] private AudioSource musicSource;
    [SerializeField] private AudioSource[] sfxSources;
    [SerializeField] private int maxSfxSources = 5;
    
    [Header("Sound Effects")]
    [SerializeField] private SoundEffect[] soundEffects;
    
    [Header("Music Tracks")]
    [SerializeField] private MusicTrack[] musicTracks;
    
    [Header("Audio Settings")]
    [SerializeField] private float masterVolume = 1f;
    [SerializeField] private float musicVolume = 0.7f;
    [SerializeField] private float sfxVolume = 1f;
    [SerializeField] private float uiVolume = 0.8f;
    [SerializeField] private bool debugMode = false;
    
    // Private state
    private Dictionary<string, SoundEffect> soundEffectLookup = new Dictionary<string, SoundEffect>();
    private Dictionary<string, MusicTrack> musicTrackLookup = new Dictionary<string, MusicTrack>();
    private Queue<AudioSource> availableSfxSources = new Queue<AudioSource>();
    private List<AudioSource> activeSfxSources = new List<AudioSource>();
    private string currentMusicId = "";
    
    private void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeAudio();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    private void Start()
    {
        SubscribeToEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void Update()
    {
        // Clean up finished SFX sources
        for (int i = activeSfxSources.Count - 1; i >= 0; i--)
        {
            var source = activeSfxSources[i];
            if (source != null && !source.isPlaying)
            {
                activeSfxSources.RemoveAt(i);
                availableSfxSources.Enqueue(source);
            }
        }
    }
    
    private void InitializeAudio()
    {
        // Initialize audio sources if not assigned
        if (musicSource == null)
        {
            musicSource = gameObject.AddComponent<AudioSource>();
            musicSource.loop = true;
            musicSource.playOnAwake = false;
        }
        
        if (sfxSources == null || sfxSources.Length == 0)
        {
            sfxSources = new AudioSource[maxSfxSources];
            for (int i = 0; i < maxSfxSources; i++)
            {
                var source = gameObject.AddComponent<AudioSource>();
                source.loop = false;
                source.playOnAwake = false;
                sfxSources[i] = source;
                availableSfxSources.Enqueue(source);
            }
        }
        else
        {
            // Initialize existing sources
            foreach (var source in sfxSources)
            {
                if (source != null)
                {
                    availableSfxSources.Enqueue(source);
                }
            }
        }
        
        // Initialize lookup dictionaries
        InitializeLookupDictionaries();
        
        // Set initial volumes
        SetMasterVolume(masterVolume);
        SetMusicVolume(musicVolume);
        SetSFXVolume(sfxVolume);
        
        if (debugMode)
        {
            Debug.Log($"Audio system initialized with {soundEffectLookup.Count} sound effects and {musicTrackLookup.Count} music tracks");
        }
    }
    
    private void InitializeLookupDictionaries()
    {
        soundEffectLookup.Clear();
        musicTrackLookup.Clear();
        
        foreach (var soundEffect in soundEffects)
        {
            if (soundEffect != null && !string.IsNullOrEmpty(soundEffect.soundId))
            {
                soundEffectLookup[soundEffect.soundId] = soundEffect;
            }
        }
        
        foreach (var musicTrack in musicTracks)
        {
            if (musicTrack != null && !string.IsNullOrEmpty(musicTrack.musicId))
            {
                musicTrackLookup[musicTrack.musicId] = musicTrack;
            }
        }
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnPlaySound += PlaySound;
        GameEvents.OnPlayMusic += PlayMusic;
        GameEvents.OnStopMusic += StopMusic;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnPlaySound -= PlaySound;
        GameEvents.OnPlayMusic -= PlayMusic;
        GameEvents.OnStopMusic -= StopMusic;
    }
    
    // Public API
    public void PlaySound(string soundId)
    {
        if (!soundEffectLookup.TryGetValue(soundId, out SoundEffect soundEffect))
        {
            if (debugMode)
            {
                Debug.LogWarning($"Sound effect not found: {soundId}");
            }
            return;
        }
        
        if (availableSfxSources.Count == 0)
        {
            if (debugMode)
            {
                Debug.LogWarning("No available SFX sources");
            }
            return;
        }
        
        var source = availableSfxSources.Dequeue();
        activeSfxSources.Add(source);
        
        source.clip = soundEffect.audioClip;
        source.volume = soundEffect.volume * sfxVolume;
        source.pitch = soundEffect.pitch;
        source.loop = soundEffect.loop;
        source.outputAudioMixerGroup = soundEffect.mixerGroup;
        source.Play();
        
        if (debugMode)
        {
            Debug.Log($"Playing sound: {soundId}");
        }
    }
    
    public void PlayMusic(string musicId)
    {
        if (currentMusicId == musicId && musicSource.isPlaying)
        {
            if (debugMode)
            {
                Debug.Log($"Music already playing: {musicId}");
            }
            return;
        }
        
        if (!musicTrackLookup.TryGetValue(musicId, out MusicTrack musicTrack))
        {
            if (debugMode)
            {
                Debug.LogWarning($"Music track not found: {musicId}");
            }
            return;
        }
        
        // Stop current music
        StopMusic();
        
        // Start new music
        musicSource.clip = musicTrack.audioClip;
        musicSource.volume = musicTrack.volume * musicVolume;
        musicSource.loop = musicTrack.loop;
        musicSource.outputAudioMixerGroup = musicTrack.mixerGroup;
        musicSource.Play();
        
        currentMusicId = musicId;
        
        if (debugMode)
        {
            Debug.Log($"Playing music: {musicId}");
        }
    }
    
    public void StopMusic()
    {
        if (musicSource.isPlaying)
        {
            musicSource.Stop();
            currentMusicId = "";
            
            if (debugMode)
            {
                Debug.Log("Music stopped");
            }
        }
    }
    
    public void PauseMusic()
    {
        if (musicSource.isPlaying)
        {
            musicSource.Pause();
            
            if (debugMode)
            {
                Debug.Log("Music paused");
            }
        }
    }
    
    public void ResumeMusic()
    {
        if (musicSource.clip != null && !musicSource.isPlaying)
        {
            musicSource.UnPause();
            
            if (debugMode)
            {
                Debug.Log("Music resumed");
            }
        }
    }
    
    public void StopAllSounds()
    {
        foreach (var source in activeSfxSources)
        {
            if (source != null && source.isPlaying)
            {
                source.Stop();
            }
        }
        
        if (debugMode)
        {
            Debug.Log("All sounds stopped");
        }
    }
    
    // Volume control
    public void SetMasterVolume(float volume)
    {
        masterVolume = Mathf.Clamp01(volume);
        if (audioMixer != null)
        {
            audioMixer.SetFloat("MasterVolume", Mathf.Log10(masterVolume) * 20f);
        }
        
        if (debugMode)
        {
            Debug.Log($"Master volume set to: {masterVolume}");
        }
    }
    
    public void SetMusicVolume(float volume)
    {
        musicVolume = Mathf.Clamp01(volume);
        if (audioMixer != null)
        {
            audioMixer.SetFloat("MusicVolume", Mathf.Log10(musicVolume) * 20f);
        }
        
        if (musicSource != null)
        {
            musicSource.volume = musicVolume;
        }
        
        if (debugMode)
        {
            Debug.Log($"Music volume set to: {musicVolume}");
        }
    }
    
    public void SetSFXVolume(float volume)
    {
        sfxVolume = Mathf.Clamp01(volume);
        if (audioMixer != null)
        {
            audioMixer.SetFloat("SFXVolume", Mathf.Log10(sfxVolume) * 20f);
        }
        
        // Update active SFX sources
        foreach (var source in activeSfxSources)
        {
            if (source != null)
            {
                source.volume = source.volume / (sfxVolume / volume);
            }
        }
        
        if (debugMode)
        {
            Debug.Log($"SFX volume set to: {sfxVolume}");
        }
    }
    
    public void SetUIVolume(float volume)
    {
        uiVolume = Mathf.Clamp01(volume);
        if (audioMixer != null)
        {
            audioMixer.SetFloat("UIVolume", Mathf.Log10(uiVolume) * 20f);
        }
        
        if (debugMode)
        {
            Debug.Log($"UI volume set to: {uiVolume}");
        }
    }
    
    // Getters
    public float GetMasterVolume() => masterVolume;
    public float GetMusicVolume() => musicVolume;
    public float GetSFXVolume() => sfxVolume;
    public float GetUIVolume() => uiVolume;
    public string GetCurrentMusicId() => currentMusicId;
    public bool IsMusicPlaying() => musicSource.isPlaying;
    
    // Public methods
    public void AddSoundEffect(SoundEffect soundEffect)
    {
        if (soundEffect != null && !string.IsNullOrEmpty(soundEffect.soundId))
        {
            soundEffectLookup[soundEffect.soundId] = soundEffect;
            if (debugMode)
            {
                Debug.Log($"Added sound effect: {soundEffect.soundId}");
            }
        }
    }
    
    public void AddMusicTrack(MusicTrack musicTrack)
    {
        if (musicTrack != null && !string.IsNullOrEmpty(musicTrack.musicId))
        {
            musicTrackLookup[musicTrack.musicId] = musicTrack;
            if (debugMode)
            {
                Debug.Log($"Added music track: {musicTrack.musicId}");
            }
        }
    }
    
    public bool HasSoundEffect(string soundId)
    {
        return soundEffectLookup.ContainsKey(soundId);
    }
    
    public bool HasMusicTrack(string musicId)
    {
        return musicTrackLookup.ContainsKey(musicId);
    }
    
    // Utility methods
    public void FadeMusicIn(string musicId, float duration = 1f)
    {
        StartCoroutine(FadeMusicCoroutine(musicId, 0f, musicVolume, duration));
    }
    
    public void FadeMusicOut(float duration = 1f)
    {
        StartCoroutine(FadeMusicCoroutine("", musicVolume, 0f, duration));
    }
    
    private System.Collections.IEnumerator FadeMusicCoroutine(string musicId, float startVolume, float endVolume, float duration)
    {
        float elapsed = 0f;
        
        // Fade out current music
        while (elapsed < duration / 2f)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / (duration / 2f);
            musicSource.volume = Mathf.Lerp(startVolume, 0f, t);
            yield return null;
        }
        
        // Change music if needed
        if (!string.IsNullOrEmpty(musicId))
        {
            PlayMusic(musicId);
        }
        
        // Fade in new music
        elapsed = 0f;
        while (elapsed < duration / 2f)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / (duration / 2f);
            musicSource.volume = Mathf.Lerp(0f, endVolume, t);
            yield return null;
        }
        
        musicSource.volume = endVolume;
    }
}

