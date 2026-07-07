INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    (
        ARRAY[
            '11111111-1111-1111-1111-111111111111',
            '22222222-2222-2222-2222-222222222222',
            '33333333-3333-3333-3333-333333333333'
        ]::uuid[]
    )[floor(random()*3)+1],
    'HOTEL-' || floor(random()*20 + 1),
    (
        ARRAY[
            'delhi',
            'mumbai',
            'bangalore',
            'pune',
            'chennai'
        ]
    )[floor(random()*5)+1],
    CURRENT_DATE - (random()*60)::int,
    CURRENT_DATE + (random()*10)::int,
    round((random()*9000 + 1000)::numeric,2),
    (
        ARRAY[
            'CONFIRMED',
            'PENDING',
            'CANCELLED'
        ]
    )[floor(random()*3)+1],
    NOW() - (random()*60 || ' days')::interval
FROM generate_series(1,100);