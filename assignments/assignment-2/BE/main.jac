import from byllm { Model }
include agent_helper;
glob llm = Model(model_name="gemini/gemini-2.0-flash");


# Assumption is that the git protocol will return a text/plain response
 # Improvement will be made to handle other content types when llm reads the URL
 node RepoInfo {
    has info: str = "";
}


# Define the CodeGenius agent node AKA Supervisor
 node CodeGenius(AgentTool) {
    def git_clone(repo: str) -> str;
    def get_repo_info(utterance: str) -> str by llm(
        method='ReAct',
        tools=([self.git_clone])
    );
}


# Define the specialized mapper
 node RepoMapper(AgentTool) {}


#Define the CodeAnalyzer agent node with methods to get Code Context Graph
 node CodeAnalyzer(AgentTool) {}


# Define the DocGenius agent node for documentation generation
 node DocGenius(AgentTool) {}


# Entry point to get past repo info
 walker get_repo_info {
    obj __specs__ {
        static has auth: bool = False;
    }

    can get_repo_info with `root entry;
}
