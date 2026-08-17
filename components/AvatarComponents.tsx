"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import type { Scenario } from "@/lib/scenarios";
import { BACKEND_URL, APP_ID } from "@/lib/config";
import { loadAvatarScript } from "@/lib/useAvatarScript";
import ChatHistoryOverlay from "./ChatHistoryOverlay";
import Image from "next/image";

export default function AvatarComponents({
  scenario,
  avatarId,
}: {
  scenario: Scenario;
  /** The specific character's avatarId picked on the characters screen. */
  avatarId: string;
}) {
  const instance = `dojo-${scenario.id}-${avatarId}`;
  const appId = APP_ID;
  const settingsGroup = `${scenario.id}-${avatarId}`;

  // Kept only the graphics readiness tracker to handle the blur mask overlay state
  const [isWidgetReady, setIsWidgetReady] = useState(false);
  const [loadFailed, setLoadFailed] = useState(false);
  // Bumped to force a full remount of the avatar-model subtree on retry —
  // see the `key` on the shellRef wrapper below. This state (isWidgetReady,
  // loadFailed) lives in this component, one level above that key, so it
  // has to be reset explicitly each time retryKey changes; a remount alone
  // wouldn't touch it.
  const [retryKey, setRetryKey] = useState(0);
  const [isHistoryOpen, setIsHistoryOpen] = useState(false);
  const shellRef = useRef<HTMLDivElement | null>(null);

  // Load the AI Avatar Team's Web Component bundle once, then nudge it.
  // Routed through the shared loadAvatarScript() singleton (lib/useAvatarScript.ts)
  // instead of creating/checking the <script> tag independently here. This
  // component used to have its own copy of this logic, which raced against
  // useAvatarProfile.ts's copy on the character-select page after a reload —
  // whichever one ran second could attach its "load" listener after the tag
  // had already finished loading and never resolve. See HANDOFF3.md.
  useEffect(() => {
    let cancelled = false;
    function nudgeResize() {
      window.dispatchEvent(new Event("resize"));
    }
    loadAvatarScript()
      .then(() => {
        if (cancelled) return;
        setTimeout(nudgeResize, 50);
        setTimeout(nudgeResize, 400);
      })
      .catch((error) => {
        // eslint-disable-next-line no-console
        console.error("[AvatarComponents] failed to load avatar script:", error);
      });

    // Catches the mobile toolbar-settle race independent of avatar
    // script load timing — forces next/image to re-evaluate `sizes`
    // and the dvh-based containers to re-measure against the real
    // viewport shortly after first paint.
    const settleTimer = setTimeout(nudgeResize, 600);

    return () => {
      cancelled = true;
      clearTimeout(settleTimer);
    };
  }, []);


  useEffect(() => {
    // Fresh attempt (first mount, or a retry bump) — always start from a
    // clean loading state rather than carrying over a stale failure.
    setIsWidgetReady(false);
    setLoadFailed(false);

    const reveal = () => {
      const shell = shellRef.current;
      if (!shell) return;
      shell
        .querySelectorAll(
          "avatar-model, avatar-captions, avatar-status, avatar-settings, avatar-inputs",
        )
        .forEach((el) => {
          (el as HTMLElement).classList.add("avatar-app-ready");
        });

      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          setIsWidgetReady(true);
        });
      });
    };

    const onReady = (e: Event) => {
      const detail = (e as CustomEvent).detail;
      if (!detail?.instance || detail.instance === instance) {
        reveal();
      }
    };

    // Emitted by AvatarController.init() when loadAvatar() genuinely
    // failed, instead of the old unconditional app:ready — see
    // HANDOFF notes: app:ready used to fire regardless of load success,
    // which hid this overlay onto a blank/broken canvas on a slow or
    // failed load. Now a failure gets its own signal, and this overlay
    // stays up (swapped to a retry state) instead of disappearing early.
    const onLoadError = (e: Event) => {
      const detail = (e as CustomEvent).detail;
      if (!detail?.instance || detail.instance === instance) {
        window.clearInterval(pollId);
        window.clearTimeout(pollTimeout);
        setLoadFailed(true);
      }
    };

    window.addEventListener("avatar:app:ready", onReady);
    window.addEventListener("avatar:app:load-error", onLoadError);

    const pollId = window.setInterval(() => {
      const model = shellRef.current?.querySelector("avatar-model") as any;
      if (model?.currentAvatarModel) {
        reveal();
        window.clearInterval(pollId);
      }
    }, 300);

    const pollTimeout = window.setTimeout(() => {
      window.clearInterval(pollId);
      reveal();
    }, 6000);

    return () => {
      window.removeEventListener("avatar:app:ready", onReady);
      window.removeEventListener("avatar:app:load-error", onLoadError);
      window.clearInterval(pollId);
      window.clearTimeout(pollTimeout);
    };
  }, [instance, retryKey]);

  const handleRetry = () => {
    setRetryKey((k) => k + 1);
  };

  return (
    <>
      <style
        dangerouslySetInnerHTML={{
          __html: `
        avatar-model:not(:defined) {
          display: block;
          position: fixed;
          inset: 0;
          z-index: 100;
          background-color: rgba(9, 9, 11, 0.8) !important;
          backdrop-filter: blur(16px);
        }
      `,
        }}
      />

      <Image
        src={scenario.backgroundImage}
        alt=""
        fill
        priority
        quality={90}
        sizes="100vw"
        className="fixed inset-0 -z-20 h-dvh object-cover object-bottom"
      />
      <div className="fixed inset-0 -z-10 h-dvh bg-black/25" />

      <div className="fixed inset-0 z-0 h-dvh flex flex-col overflow-hidden">
        <div className="flex-1 min-h-0 flex relative">
          {/* Overlay stays visible until the model reports ready OR a
              distinct failure state, instead of unconditionally
              disappearing once init() merely finishes running. */}
          <div
            className={`absolute inset-0 z-40 flex flex-col items-center justify-center bg-zinc-950/80 backdrop-blur-xl transition-opacity duration-500 ease-out ${
              isWidgetReady ? "opacity-0 pointer-events-none" : "opacity-100"
            }`}
            aria-hidden={isWidgetReady}
          >
            {loadFailed ? (
              <div className="flex flex-col items-center gap-4 text-center max-w-sm px-6">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-hanko-red/10 border border-hanko-red/30 shadow-xl">
                  <svg
                    className="h-7 w-7 text-hanko-red stroke-current stroke-[1.5] fill-none"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M12 9v3.75m0 3.75h.008v.008H12v-.008zM21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>

                <div className="space-y-2">
                  <h4 className="text-sm font-bold uppercase tracking-wider text-white flex flex-col gap-0.5">
                    <span>Couldn&rsquo;t load the dojo</span>
                    <span className="text-[11px] font-medium tracking-normal text-zinc-400 lowercase italic">
                      （読み込みに失敗しました）
                    </span>
                  </h4>
                  <p className="text-xs text-zinc-400 leading-normal">
                    Something went wrong loading your practice session.
                  </p>
                </div>

                <button
                  onClick={handleRetry}
                  className="mt-1 flex h-9 items-center gap-2 rounded-full bg-ai-indigo hover:opacity-90 active:scale-95 text-white px-5 transition-all duration-150 ease-out text-xs font-bold uppercase tracking-wider cursor-pointer"
                >
                  Try again
                </button>
              </div>
            ) : (
              <div className="flex flex-col items-center gap-4 text-center max-w-sm px-6 animate-pulse">
                <div className="flex h-16 w-16 items-center justify-center rounded-full bg-white/10 border border-white/20 shadow-xl">
                  <svg
                    className="h-7 w-7 text-red-400 stroke-current stroke- fill-none"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z"
                    />
                  </svg>
                </div>

                <div className="space-y-2">
                  <h4 className="text-sm font-bold uppercase tracking-wider text-white flex flex-col gap-0.5">
                    <span>Entering Dojo</span>
                    <span className="text-[11px] font-medium tracking-normal text-zinc-400 lowercase italic">
                      （道場に入る）
                    </span>
                  </h4>
                  <p className="text-xs text-zinc-400 leading-normal flex flex-col gap-1">
                    <span>Getting your practice session ready...</span>
                    <span className="text-zinc-500 font-sans">
                      練習の準備をしています...
                    </span>
                  </p>
                </div>
              </div>
            )}
          </div>

          <div
            key={`${instance}-${retryKey}`}
            className="flex-1 min-h-0 flex flex-col overflow-visible"
            ref={shellRef}
          >
            <div className="relative w-full flex-1 min-h-0">
              <avatar-model
                backend={BACKEND_URL}
                app-id={appId}
                settings-scope="app"
                settings-group={settingsGroup}
                instance={instance}
                avatar-scale="1"
                avatar-vertical-offset="-1.25"
                className="h-full"
              />

              <avatar-status
                instance={instance}
                className="absolute top-3 left-3 z-9"
              />

              <div className="absolute top-4 right-4 z-10 flex items-center gap-2.5">
                <button
                  onClick={() => setIsHistoryOpen(true)}
                  aria-label="View chat history"
                  title="Chat history"
                  className="group flex h-10 w-10 items-center justify-center rounded-full bg-[#efe8d8] border border-[#d9d0ba] text-[#4a5164] hover:bg-[#223a5e] hover:border-[#223a5e] hover:text-[#f7f3ea] active:scale-95 transition-all duration-150 ease-out cursor-pointer"
                >
                  <svg
                    className="w-5 h-5 fill-none stroke-current stroke-[2]"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"
                    />
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M3 3v5h5"
                    />
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M12 7v5l4 2"
                    />
                  </svg>
                </button>
                <Link
                  href="/"
                  className="group/exit flex h-9 items-center gap-2 rounded-full bg-red-600 hover:bg-red-500 active:bg-red-700 border border-red-700 hover:border-red-600 text-white px-4 transition-all duration-150 ease-out active:scale-95 text-xs font-bold uppercase tracking-wider no-underline shadow-md shadow-red-950/20 cursor-pointer"
                >
                  <svg
                    className="w-3.5 h-3.5 fill-none stroke-current stroke-[2.5] transition-transform duration-200 group-hover/exit:rotate-90"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M6 18L18 6M6 6l12 12"
                    />
                  </svg>
                  <span>Exit Session</span>
                </Link>

                <avatar-settings
                  instance={instance}
                  className={`relative ${
                    process.env.NEXT_PUBLIC_SHOW_DEV_CONTROLS === "true"
                      ? ""
                      : "hidden"
                  }`}
                />
              </div>

              <div className="absolute bottom-3 left-1/2 -translate-x-1/2 w-full max-w-2xl px-3 flex flex-col">
                <avatar-captions instance={instance} />
                <avatar-inputs instance={instance} backend={BACKEND_URL} className="shadow-2xl" />
              </div>
            </div>
          </div>
        </div>
      </div>
      <ChatHistoryOverlay
        open={isHistoryOpen}
        onClose={() => setIsHistoryOpen(false)}
        instance={instance}
      />
    </>
  );
}