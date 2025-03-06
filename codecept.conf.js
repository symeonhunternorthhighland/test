require("dotenv").config();
const _user = (process.env.profile === "remote") ? process.env.BROWSERSTACK_USERNAME : undefined

const _key = (process.env.profile === "remote") ? process.env.BROWSERSTACK_ACCESS_KEY : undefined
const build = process.env.BROWSERSTACK_BUILD_NAME;

exports.config = {
  helpers: {
    WebDriver: {
      url: "{{BASE_URL}}",
      //MicrosoftEdge//firefox//chrome
      browser: "chrome",
      restart: true,
      user:_user,
      key: _key,
      windowSize: "1920x1680",
      waitForTimeout: 10000,
      waitForElement: 5000,
      smartWait: 5000,
      waitForText: 5000,
      waitForInvisible: 10000,
      desiredCapabilities: {
        ...(process.env.profile === "remote" && {
          buildName: process.env.BROWSERSTACK_BUILD_NAME,
        }), 
      },
    },
    BrowserStackSession: {
      require: "./utils/browserstack_session.js",
    },
  },
  include: {
    I: "./steps_file.js",
  },
  bootstrap: null,
  timeout: null,
  teardown: null,
  gherkin: {
    features: "./features/**/*.feature",
    steps: ["./step_definitions/commonSteps.js"],
  },
  plugins: {
    autoLogin: {
      enabled: true,
      saveToFile: false,
      inject: "loginAs",
      users: {
        admin: {},
      },
    },
    screenshotOnFail: {
      enabled: true,
    },
    customHooks: {
      require: "./utils/hooks",
      enabled: true,
    },
    tryTo: {
      enabled: true,
    },
    retryFailedStep: {
      enabled: true,
      minTimeout: 3000,
    },
    retryTo: {
      enabled: true,
    },
    eachElement: {
      enabled: true,
    },
    pauseOnFail: {},
    allure: {
      enabled: true,
      require: "@codeceptjs/allure-legacy",
      outputDir: "./out",
    },
    customLocator: {
      enabled: true,
      prefix: "&",
      attribute: "href",
    },
  },
  tests: "./features/**/*.feature",
  name: "{{PROJECT_NAME}}",
};
