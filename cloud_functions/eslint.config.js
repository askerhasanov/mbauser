// eslint.config.js
module.exports = [
  {
    files: ["**/*.js"],
    ignores: ["node_modules/**"],
    languageOptions: {
      ecmaVersion: 2018,
      globals: {
        es6: true,
        node: true,
      },
    },
    plugins: {
      // You can add any plugins if needed
    },
    rules: {
      "no-restricted-globals": ["error", "name", "length"],
      "prefer-arrow-callback": "error",
      "quotes": ["error", "double", { "allowTemplateLiterals": true }],
    },
  },
  {
    files: ["**/*.spec.*"],
    languageOptions: {
      globals: {
        mocha: true, // Mocha environment for test files
      },
    },
    rules: {
      // You can define specific rules for spec files if needed
    },
  },
];