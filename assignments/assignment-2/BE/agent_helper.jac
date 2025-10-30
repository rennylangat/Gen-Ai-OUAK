# This is the agent helper file for the CodeBase Genius AI tool.
 # It contains common nodes and utilities used by various agents.
 import from dotenv { load_dotenv }
node Memory {}


node Session {}


node AgentTool {}


with entry {
    load_dotenv();
}
