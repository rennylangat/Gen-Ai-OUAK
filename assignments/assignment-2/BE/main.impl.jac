# This file contains the main implementation for the CodeBase Genius AI tool.
 impl CodeGenius.add_url{
    url_node = GitUrl(gitUrl=gitUrl);
    self ++> url_node;
    return "Url received";
}


impl CodeGenius.git_clone{
    git_url_node = GitUrl(url=repo);
}


impl CodeGenius.get_readme_summary{
    readme_summary = ReadMeSummary(readme_summary=readme_summary);
    self ++> readme_summary;
    return "Reposity Summary Created";
}


impl CodeGenius.create_code_ctx_graph{
    cde_ctx_graph = CodeContextGraph(cde_ctx_graph=cde_ctx_graph);
    self ++> cde_ctx_graph;
    return "Code Context Graph Created";
}


sem CodeGenius. get_repo_info= "Traverse this repository and return a structured representation of files and folders get into details of the top level folders down to their children while ignoring irrelevant directories such as .git or node_modules. Return the result as a markdown or ASCII diagram or the representation Repository:";
sem CodeGenius. route_and_run= "Select and execute only one tool provided";


impl get_repo_info.get_repo_info{
    print("We have landed here");
    repo_handler_node = [root-->( ` ? RepoInfo ) ];
    if not repo_handler_node {
        report 'RepoInfo node not found.' ;
        disengage;
    }
    report [repo_handler_node[0]-->( ` ? RepoInfo ) ] ;
}
