import from byllm { Model }
include agent_helper;
import from utils { get_curr_datetime }


glob llm = Model(model_name="gemini/gemini-2.5-pro");


#Confirmation made, Agent will read the URL and return markdown. We Store the checked URLs
 node GitUrl {
    has gitUrl: str = "";
}


node ReadMeSummary {
    has readme_summary: str = "";
}


node CodeContextGraph {
    has cde_ctx_graph: str = "";
}


# Helps the Agents connect to the root
 edge Delegate {}


node RepoMapper {
    has repo_name: str = "";
    has repo_map: str = "";
}


# Define the CodeGenius agent node AKA Supervisor
 node CodeGenius(AgentTool) {
    def add_url(gitUrl: str) -> str;
    def get_readme_summary(readme_summary: str) -> str;
    def create_code_ctx_graph(cde_ctx_graph: str) -> str;
    def get_repo_info(utterance: str) -> str by llm(
        method='ReAct',
        tools=([self.add_url])
    );

    def readme_summary()  -> str by llm(
        method='ReAct',
        tools=([self.get_readme_summary])
    );

    def crt_cde_ctx_graph()  -> str by llm(
        method="ReAct",
        tools=([self.create_code_ctx_graph])
    );

    def route_and_run(utterance: str, history: str) -> str by llm(
        method="ReAct",
        tools=(
        [self.add_url,
        self.get_repo_info,
        self.readme_summary,
        self.crt_cde_ctx_graph,
        ])
    );
}


enum RoutingNodes { GEN_CHAT = "GeneralChat" }


# Define the specialized mapper
 node RepoMapper(AgentTool) {}


#Define the CodeAnalyzer agent node with methods to get Code Context Graph
 node CodeAnalyzer(AgentTool) {}


# Define the DocGenius agent node for documentation generation
 node DocGenius(AgentTool) {}


node GeneralChat(AgentTool) {
    def chat(utterance: str, history: str) -> str by llm();
    def route_and_run(utterance: str, history: str) -> str by llm(
        method='ReAct',
        tools=([self.chat])
    );
}


walker git_analyzer(agent) {
    def route_to_node(utterance: str, history: str) -> RoutingNodes by llm();
}


walker query_func_relationships(agent) {
    def route_to_node(utterance: str, history: str) -> RoutingNodes by llm();
}


# Entry point to get past repo info
 walker get_repo_info {
    obj __specs__ {
        static has auth: bool = False;
    }

    can get_repo_info with `root entry;
}
