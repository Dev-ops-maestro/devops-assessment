INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKING_CREATED',
    jsonb_build_object(
        'source','website',
        'message','Booking created successfully'
    ),
    created_at
FROM hotel_bookings
LIMIT 50;


INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'PAYMENT_SUCCESS',
    jsonb_build_object(
        'payment_method','CARD',
        'currency','USD'
    ),
    created_at + interval '5 minutes'
FROM hotel_bookings
LIMIT 30;


INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKING_CANCELLED',
    jsonb_build_object(
        'reason','Customer request'
    ),
    created_at + interval '1 day'
FROM hotel_bookings
WHERE status='CANCELLED'
LIMIT 20;