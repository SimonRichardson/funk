package funk.actors.dispatch;

import funk.types.AnyRef;

using funk.Funk;

enum SystemMessage {
    Create(uid : String);
}
