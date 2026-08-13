"use client";

import { useEffect, useState, useCallback, useRef } from "react";

type ChatMessage = {
  role: "user" | "assistant";
  content: string;
  text?: string;
  text_en?: string;
  text_ja?: string;
  character_name?: string;
  time: string;
};

const CHAT_HISTORY_EVENT = "avatar:chat-history";
const OPEN_REQUEST_EVENT = "avatar:open-chat-history";
const CLEAR_REQUEST_EVENT = "avatar:clear-chat-history";
const TIMEOUT_MS = 6000;

/**
 *    SCOPING: AvatarController.refreshHistory()/clearChatHistory() both
 *    filter by the CURRENT character (avatarName), unlike the old direct
 *    /history and /reset calls here, which were deliberately unscoped
 *    (full cross-character history, matching the settings panel's
 *    documented "doesn't scope by avatar today" /reset behavior). Opening
 *    this overlay now shows/clears only the active character's messages.
 *
 *    SIDE EFFECT: dispatching avatar:open-chat-history also fires
 *    AvatarSettings.js's own _onOpenChatHistory listener (if that custom
 *    element is present on the page), which opens ITS built-in
 *    chat-history overlay too. If both this component and <avatar-settings>
 *    are mounted, opening this overlay will also pop open the native one
 *    underneath/behind it.
 */
export default function ChatHistoryOverlay({
  open,
  onClose,
  instance,
  characterName,
}: {
  open: boolean;
  onClose: () => void;
  instance: string;
  characterName?: string;
}) {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [responseLanguage, setResponseLanguage] = useState<string>("en");
  const [avatarName, setAvatarName] = useState<string | undefined>(characterName);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [clearing, setClearing] = useState(false);
  const [confirmingClear, setConfirmingClear] = useState(false);
  const clearingRef = useRef(false);
  const scrollRef = useRef<HTMLDivElement | null>(null);

  const formatTime = useCallback((iso: string): string => {
    try {
      return new Date(iso).toLocaleTimeString([], { hour: "numeric", minute: "2-digit" });
    } catch {
      return "";
    }
  }, []);

  // Passive listener — always attached while mounted, not just while open,
  // so a broadcast that lands right as the overlay opens isn't missed.
  useEffect(() => {
    function handleChatHistory(e: Event) {
      const detail = (e as CustomEvent).detail;
      if (!detail || detail.instance !== instance) return;

      setMessages(Array.isArray(detail.history) ? detail.history : []);
      if (detail.avatarName) setAvatarName(detail.avatarName);
      if (detail.responseLanguage) setResponseLanguage(detail.responseLanguage);
      setLoading(false);
      setError(null);

      if (clearingRef.current) {
        clearingRef.current = false;
        setClearing(false);
        setConfirmingClear(false);
      }
    }

    window.addEventListener(CHAT_HISTORY_EVENT, handleChatHistory as EventListener);
    return () => {
      window.removeEventListener(CHAT_HISTORY_EVENT, handleChatHistory as EventListener);
    };
  }, [instance]);

  // On open: request a fresh snapshot rather than assuming the last
  // passive broadcast (from init/select/ask) is still current.
  useEffect(() => {
    if (!open) {
      setConfirmingClear(false);
      return;
    }

    setLoading(true);
    setError(null);
    window.dispatchEvent(
      new CustomEvent(OPEN_REQUEST_EVENT, { detail: { instance } })
    );

    const timeout = setTimeout(() => {
      setLoading((cur) => {
        if (cur) setError("Couldn't load chat history. Check your connection and try again.");
        return false;
      });
    }, TIMEOUT_MS);

    return () => clearTimeout(timeout);
  }, [open, instance]);

  // Always land at the newest message; user can still scroll up manually
  // for older ones. Runs after messages update (new snapshot, new reply)
  // and whenever the overlay opens.
  useEffect(() => {
    if (!open) return;
    const el = scrollRef.current;
    if (!el) return;
    el.scrollTop = el.scrollHeight;
  }, [open, messages]);

  const handleClear = () => {
    setClearing(true);
    setError(null);
    clearingRef.current = true;
    window.dispatchEvent(
      new CustomEvent(CLEAR_REQUEST_EVENT, { detail: { instance } })
    );

    // Fallback in case no chat-history broadcast follows (e.g. backend
    // unreachable) — clearChatHistory() still calls refreshHistory() in a
    // try/finally-less path, so this should be rare, but avoid getting
    // stuck on "Clearing…" forever.
    setTimeout(() => {
      if (clearingRef.current) {
        clearingRef.current = false;
        setClearing(false);
        setConfirmingClear(false);
        setError("Couldn't confirm the history was cleared. Try again.");
      }
    }, TIMEOUT_MS);
  };

  // Mirrors AvatarSettings.js's renderHistory()/appendHistoryItem(): pick
  // text_en/text_ja by responseLanguage rather than the generic
  // content/text field (that field is what was silently showing English
  // for Japanese-mode replies — text_en/text_ja are what the backend
  // actually stores per-language on every assistant turn). In "both" mode,
  // an assistant reply renders as two separate bubbles, same as native.
  type DisplayBubble = { key: string; isUser: boolean; body: string; time: string };

  const showEn = responseLanguage === "en" || responseLanguage === "both";
  const showJa = responseLanguage === "ja" || responseLanguage === "both";

  const bubbles: DisplayBubble[] = [];
  messages.forEach((m, i) => {
    const time = m.time || "";
    if (m.role === "assistant") {
      const preferEn = showEn && m.text_en;
      const preferJa = showJa && m.text_ja;
      if (preferEn) bubbles.push({ key: `${i}-en`, isUser: false, body: m.text_en!, time });
      if (preferJa) bubbles.push({ key: `${i}-ja`, isUser: false, body: m.text_ja!, time });
      if (!preferEn && !preferJa) {
        const fallback = m.text_en || m.text_ja || m.text || m.content || "";
        if (fallback) bubbles.push({ key: `${i}-fallback`, isUser: false, body: fallback, time });
      }
    } else {
      const body = m.text || m.content || "";
      if (body) bubbles.push({ key: `${i}-user`, isUser: true, body, time });
    }
  });

  if (!open) return null;

  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center bg-ink/50 backdrop-blur-sm px-4"
      onClick={onClose}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        className="w-full max-w-2xl max-h-[90vh] flex flex-col rounded-[14px] bg-paper border border-line shadow-2xl font-body overflow-hidden"
      >
        {/* Header */}
        <div className="flex items-center justify-between px-5 py-4 border-b border-line">
          <div>
            <h3 className="text-base font-display font-bold text-ink leading-tight">
              Chat history
            </h3>
            <p className="text-[11px] text-ink-soft leading-tight">
              会話の記録{avatarName ? ` · ${avatarName}` : ""}
            </p>
          </div>
          <button
            onClick={onClose}
            aria-label="Close chat history"
            className="h-8 w-8 flex items-center justify-center rounded-full text-ink-soft hover:bg-paper-dim hover:text-ink transition cursor-pointer"
          >
            <svg className="w-4 h-4 fill-none stroke-current stroke-[2]" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Body */}
        <div ref={scrollRef} className="flex-1 overflow-y-auto px-5 py-4 space-y-4">
          {loading && (
            <div className="flex flex-col items-center justify-center gap-2 py-10 text-center">
              <p className="text-sm text-ink-soft">Loading history…</p>
            </div>
          )}

          {error && !loading && (
            <div className="rounded-card border border-hanko-red/30 bg-hanko-red/5 px-4 py-3">
              <p className="text-sm text-hanko-red">{error}</p>
            </div>
          )}

          {!loading && !error && messages.length === 0 && (
            <div className="flex flex-col items-center justify-center gap-1 py-12 text-center">
              <p className="text-sm font-medium text-ink">No messages yet</p>
              <p className="text-xs text-ink-soft">
                Start talking and your conversation will show up here.
              </p>
            </div>
          )}

          {bubbles.map((b) => (
            <div key={b.key} className={`flex flex-col ${b.isUser ? "items-end" : "items-start"}`}>
              <div className="flex items-baseline gap-2 mb-1 px-1">
                <span className="text-[11px] font-semibold uppercase tracking-wide text-ink-soft">
                  {b.isUser ? "You" : avatarName || "Character"}
                </span>
                {b.time && (
                  <span className="text-[11px] text-ink-soft/70">{formatTime(b.time)}</span>
                )}
              </div>
              <div
                className={`max-w-[85%] rounded-card px-4 py-2.5 text-sm leading-relaxed ${
                  b.isUser
                    ? "bg-ai-indigo text-white"
                    : "bg-paper-dim text-ink border border-line"
                }`}
              >
                {b.body}
              </div>
            </div>
          ))}
        </div>

        {/* Footer */}
        {messages.length > 0 && (
          <div className="flex items-center justify-end gap-3 px-5 py-4 border-t border-line">
            {confirmingClear ? (
              <div className="flex items-center gap-2">
                <span className="text-xs text-ink-soft">Clear the whole conversation?</span>
                <button
                  onClick={handleClear}
                  disabled={clearing}
                  className="text-xs font-bold uppercase tracking-wide text-paper bg-hanko-red hover:opacity-90 disabled:opacity-50 rounded-full px-3 py-1.5 transition cursor-pointer"
                >
                  {clearing ? "Clearing…" : "Confirm"}
                </button>
                <button
                  onClick={() => setConfirmingClear(false)}
                  disabled={clearing}
                  className="text-xs font-medium text-ink-soft hover:text-ink transition cursor-pointer"
                >
                  Cancel
                </button>
              </div>
            ) : (
              <button
                onClick={() => setConfirmingClear(true)}
                className="text-xs font-bold uppercase tracking-wide text-hanko-red hover:opacity-80 transition cursor-pointer"
              >
                Reset chat
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
}