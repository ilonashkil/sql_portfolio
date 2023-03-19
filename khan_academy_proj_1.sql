/* TASK 
 Create your own store! Your store should sell one type of things, like clothing or bikes, whatever you want your store to specialize in. You should have a table for all the items in your store, and at least 5 columns for the kind of data you think you'd need to store. You should sell at least 15 items, and use select statements to order your items by price and show at least one statistic about the items. */
CREATE TABLE store (
    item_id INTEGER PRIMARY KEY,
    item_name TEXT,
    item_description TEXT,
    item_color TEXT,
    item_price REAL
);


INSERT INTO
    store
VALUES
    (
        1,
        'Basic T-Shirt',
        'Plain t-shirt',
        'White',
        9.99
    ),
    (
        2,
        'Basic T-Shirt',
        'Plain t-shirt',
        'Black',
        9.99
    ),
    (
        3,
        'Graphic T-Shirt',
        'T-shirt with graphic design',
        'Blue',
        14.99
    ),
    (
        4,
        'V-Neck T-Shirt',
        'T-shirt with v-neck design',
        'Grey',
        12.99
    ),
    (
        5,
        'Striped T-Shirt',
        'T-shirt with stripes',
        'Red',
        11.99
    ),
    (
        6,
        'Pocket T-Shirt',
        'T-shirt with front pocket',
        'Green',
        13.99
    ),
    (
        7,
        'Long Sleeve T-Shirt',
        'T-shirt with long sleeves',
        'White',
        16.99
    ),
    (
        8,
        'Hooded T-Shirt',
        'T-shirt with hood',
        'Black',
        19.99
    ),
    (
        9,
        'Ringer T-Shirt',
        'T-shirt with contrasting collar and sleeve bands',
        'Yellow',
        10.99
    ),
    (
        10,
        'Henley T-Shirt',
        'T-shirt with buttoned placket',
        'Grey',
        17.99
    ),
    (
        11,
        'Baseball T-Shirt',
        'T-shirt with raglan sleeves',
        'Black/White',
        15.99
    ),
    (
        12,
        'Pocket Tank Top',
        'Tank top with front pocket',
        'Blue',
        9.99
    ),
    (
        13,
        'Muscle Tank Top',
        'Sleeveless top with wide armholes',
        'White',
        11.99
    ),
    (
        14,
        'Racerback Tank Top',
        'Tank top with racerback design',
        'Pink',
        12.99
    ),
    (
        15,
        'Crop Top',
        'Short top that exposes the midriff',
        'Black',
        14.99
    );


SELECT
    item_name,
    item_price
FROM
    store
ORDER BY
    item_price ASC;


SELECT
    AVG(item_price) AS avg_price
FROM
    store;