# This file contains the main implementation for the CodeBase Genius AI tool.
 impl CodeGenius.git_clone{
    git_url_node = GitUrl(url=repo);
}


enum RoutingNodes { GEN_CHAT = "GeneralChat" }


impl get_repo_info.get_repo_info{
    print("We have landed here");
    repo_handler_node = [root-->( ` ? RepoInfo ) ];
    if not repo_handler_node {
        report 'RepoInfo node not found.' ;
        disengage;
    }
    report [repo_handler_node[0]-->( ` ? RepoInfo ) ] ;
}
