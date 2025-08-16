using System;
using UnityEngine;

public static class InputEvents
{
    public static event Action<Vector2> OnMoveInput;
    public static event Action<bool> OnSprintInput;
    public static event Action OnInteractInput;
    public static event Action OnAdvanceInput;
    public static event Action<int> OnChoiceInput;
    public static event Action OnPauseInput;
    public static event Action OnRestartInput;
    
    public static void InvokeMoveInput(Vector2 direction) => OnMoveInput?.Invoke(direction);
    public static void InvokeSprintInput(bool isPressed) => OnSprintInput?.Invoke(isPressed);
    public static void InvokeInteractInput() => OnInteractInput?.Invoke();
    public static void InvokeAdvanceInput() => OnAdvanceInput?.Invoke();
    public static void InvokeChoiceInput(int choiceIndex) => OnChoiceInput?.Invoke(choiceIndex);
    public static void InvokePauseInput() => OnPauseInput?.Invoke();
    public static void InvokeRestartInput() => OnRestartInput?.Invoke();
}

