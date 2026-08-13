export const BACKEND_URL =
  process.env.NEXT_PUBLIC_BACKEND_URL || "http://localhost:8000";

export const AVATAR_SCRIPT_URL = "https://ai-avatar-ui-ghost.vercel.app/ai-avatar-ui.js";

export const APP_ID = "ai-dojo";

// The avatarId in the AI Avatar Team's roster (AvatarSources.js) that DOJO
// scenarios re-persona. If this is wrong, ask the AI Avatar Team for the
// correct id — everything else in the integration still works.
export const DOJO_AVATAR_ID = "japanese_roleplay";
