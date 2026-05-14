const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

let projects = {};

// TEMP AI (we replace with OpenAI later)
function fakeAI(prompt) {

    if (prompt.toLowerCase().includes("combat")) {
        return {
            projectName: "CombatSystem",
            actions: [
                {
                    type: "createScript",
                    location: "ServerScriptService",
                    name: "CombatServer",
                    code: `
print("Combat system loaded on server")
`
                },
                {
                    type: "createScript",
                    location: "StarterPlayerScripts",
                    name: "CombatClient",
                    code: `
print("Combat system loaded on client")
`
                }
            ]
        };
    }

    return {
        projectName: "EmptyProject",
        actions: []
    };
}

app.post("/generate", (req, res) => {

    const { prompt, userId } = req.body;

    const project = fakeAI(prompt);

    projects[userId] = project;

    res.json(project);
});

app.get("/project/:userId", (req, res) => {

    const project = projects[req.params.userId];

    if (!project) return res.status(404).json({ error: "No project" });

    res.json(project);
});

app.listen(PORT, () => {
    console.log("AI backend running on port", PORT);
});
