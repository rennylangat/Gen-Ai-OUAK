# This is the agent helper file for the CodeBase Genius AI tool.
 # It contains common nodes and utilities used by various agents.
 import sys;
import from dotenv { load_dotenv }
import from utils { get_curr_datetime }


node Memory {}


node Session {
    has history: list = [];
    has created_at: str = get_curr_datetime();

    def add_history(entry: str) {
        self.history = self.history + [entry];
    }

    def get_history -> str {
        return "\n".join(self.history[ -10 : ]);
    }
}


node AgentTool {
    def route_and_run(utterance: str, history: str) -> str abs;
    can execute with `root entry {
        session = visitor.session;
        response = self.route_and_run(visitor.utterance, session.get_history());
        session.add_history("user:" + visitor.utterance + "\nai:" + response);
        report {"session_id" : jid(visitor.session) , "response" : response } ;
    }
}


enum RoutingNodes { GEN_CHAT = "General Chat" }


walker agent {
    has utterance: str = "";
    has session_id: str = "";

    obj __specs__ {
        has auth: bool = False;
    }

    def get_node_class(class_name: str) {
        main_mod = sys.modules.get("__main__");
        if main_mod and hasattr(main_mod, class_name)  {
            return getattr(main_mod, class_name, None);
        }
        for (mod.name, mod) in sys.modules.items() {
            if mod and hasattr(mod, class_name)  {
                return getattr(mod, class_name);
            }
        }
    }

    def route_to_node(utterance: str, history: str) -> RoutingNodes abs;
    can execute with `root entry {
        memory_list = [root-->( ` ? Memory ) ];
        if not memory_list {
            memory_list = root ++> Memory();
        }
        print("Memory ", memory_list[0]);
        memory = memory_list[0];
        if not self.session_id {
            sesson_list = memory ++> Session();
            self.session = sesson_list[0];
        } else {
            self.session = & (self.session_id);
        }
        routed_node = self.route_to_node(self.utterance, self.session.get_history());
        node_cls = self.get_node_class(routed_node.value);
        if not node_cls {
            print("Failed to get node class");
            return;
        }
        node_inst = node_cls();
        visit [-->( ` ? node_cls ) ] else {
            attached_route_node = here ++> node_inst;
            visit attached_route_node;
        }
    }
}


walker get_all_sessions {
    obj __specs__ {
        has auth: bool = False;
    }

    can get_all_sessions with `root entry {
        memory_list = [here-->( ` ? Memory ) ];
        if not memory_list {
            report "No Sessions found" ;
            return;
        }
        memory = memory_list[0];
        sesson_list = [memory-->( ` ? Session ) ];
        report [ {"id" : jid(session) , "created_at" : session.created_at } for session in sesson_list ] ;
    }
}


with entry {
    load_dotenv();
}
