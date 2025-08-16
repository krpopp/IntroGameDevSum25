public interface IGameStateListener
{
    void OnGameStateChanged(GameState newState);
    void OnTimerChanged(float timeRemaining);
    void OnTemperatureChanged(int temperatureFrame);
    void OnItemCollected(string itemId);
    void OnGameSuccess();
    void OnGameFailure();
}

