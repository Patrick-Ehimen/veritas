import fs from "fs";
import path from "path";
const projectRoot = path.resolve(process.cwd());
const envExamplePath = path.join(projectRoot, ".env.example");
const envPath = path.join(projectRoot, ".env");
function setupEnv() {
  console.log("Checking environment setup...");
  if (!fs.existsSync(envExamplePath)) {
    console.error("Error: .env.example file not found. Please create one.");
    process.exit(1);
  }
  if (!fs.existsSync(envPath)) {
    console.log(".env file not found. Copying from .env.example.");
    fs.copyFileSync(envExamplePath, envPath);
    console.log(
      "Successfully created .env file. Please fill in the required variables."
    );
    return;
  }
  const exampleEnv = fs.readFileSync(envExamplePath, "utf-8");
  const actualEnv = fs.readFileSync(envPath, "utf-8");
  const exampleKeys = exampleEnv
    .split("\n")
    .map((line) => line.split("=")[0])
    .filter((key) => key.trim() !== "" && !key.startsWith("#"));
  const missingKeys = exampleKeys.filter((key) => !actualEnv.includes(key));
  if (missingKeys.length > 0) {
    console.warn(
      "Warning: The following required environment variables are missing from your .env file:"
    );
    missingKeys.forEach((key) => console.warn(`- ${key}`));
    console.warn("Please update your .env file.");
  } else {
    console.log("Environment setup is correct.");
  }
}
setupEnv();
