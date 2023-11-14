const { getRandomCHNJoke } = require("random-jokes");
const core = require("@actions/core");

async function run() {
    const joke = await getRandomCHNJoke();
    console.log(joke);
    console.log("AWS_ACCESS_KEY_ID", process.env.AWS_ACCESS_KEY_ID);
    console.log("AWS_SECRET_ACCESS_KEY", process.env.AWS_SECRET_ACCESS_KEY);
    core.setOutput("random-joke", joke);
}

run();
