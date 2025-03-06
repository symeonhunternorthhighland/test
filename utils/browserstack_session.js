/* eslint-disable no-underscore-dangle */
require("dotenv").config();
const Helper = require("@codeceptjs/helper");
const { config } = require("codeceptjs");

class BrowserStackHelper extends Helper {
  /**
   * @protected
   */
  _init() {
    if (process.env.profile === "remote") {
      config.append({
       
        plugins: {
          wdio: {
            services: ["browserstack"],
            user: process.env.BROWSERSTACK_USERNAME,
            key: process.env.BROWSERSTACK_ACCESS_KEY,
          },
        },
      });
    }
  }

  /**
   * @protected
   */
  _after() {
    if (process.env.profile === "remote") {
      const sessionId = this.helpers.WebDriver.browser.sessionId;
      console.log(
        "Test completed!\n Link to your video: https://automate.browserstack.com/dashboard/v2/sessions/%s \n\n",
        sessionId
      );
    }
  }
}

module.exports = BrowserStackHelper;
