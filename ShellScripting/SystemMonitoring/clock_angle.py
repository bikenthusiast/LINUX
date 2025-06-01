def clock_angle(hour: int, minute: int) -> float:
    """
    Calculates the angle between the hour and minute hands of a clock.

    Args:
        hour: The hour (0-23).
        minute: The minute (0-59).

    Returns:
        The smaller angle in degrees between the clock hands.
    """
    if not (0 <= hour <= 23 and 0 <= minute <= 59):
        raise ValueError("Hour must be between 0 and 23, and minute between 0 and 59.")

    # Adjust hour to 12-hour format
    hour = hour % 12

    # Calculate angles
    minute_angle = minute * 6
    hour_angle = (hour * 30) + (minute * 0.5)

    # Calculate the absolute difference
    angle = abs(hour_angle - minute_angle)

    # Return the smaller angle
    return min(angle, 360 - angle)
