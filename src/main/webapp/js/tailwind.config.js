/*
 * Shared Tailwind CDN theme: "forest" dark-green palette and Inter font.
 * Loaded right after https://cdn.tailwindcss.com in every JSP.
 */
tailwind.config = {
    theme: {
        extend: {
            colors: {
                forest: {
                    50:  '#eef6f1',
                    100: '#d5eadd',
                    200: '#abd3bb',
                    300: '#7db896',
                    400: '#4f9a72',
                    500: '#2f7d58',
                    600: '#236847',
                    700: '#1b543a',
                    800: '#144330',
                    900: '#0f3d2e',
                    950: '#08251b'
                }
            },
            fontFamily: {
                sans: ['Inter', 'Segoe UI', 'Arial', 'sans-serif']
            }
        }
    }
};
