"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { BACKEND_URL, APP_ID } from "@/lib/config";
import { useAvatarProfile } from "@/lib/useAvatarProfile";

type CharacterCardProps = {
  scenarioId: string;
  avatarId: string;
  fallbackLabel: string;
  persona?: string;
  cardIndex: number;
};

export default function CharacterCard({
  scenarioId,
  avatarId,
  fallbackLabel,
  persona,
  cardIndex,
}: CharacterCardProps) {
  const instance = `dojo-${scenarioId}-${avatarId}`;
  const appId = APP_ID;
  const settingsGroup = `${scenarioId}-${avatarId}`;

  const { profile, status } = useAvatarProfile(instance);

  // tracks whether the avatar-settings web component has actually
  // signaled readiness (avatar:update-profile / avatar:app:ready), separate
  // from the useAvatarProfile fetch status.
  const [isAppReady, setIsAppReady] = useState(false);

  // Detect if we are actively fetching live details from the database
  // OR waiting on the web component's own ready signal.
const isSyncingData =
  status === "loading" &&
  (!profile || !profile.name || !profile.persona || !isAppReady);

  const displayName = profile?.name ?? fallbackLabel;
  const displayPersona = profile?.persona ?? persona;

  const settingsRef = useRef<HTMLElement | null>(null);

  useEffect(() => {
    function nudgeResize() {
      window.dispatchEvent(new Event("resize"));
    }
    const t1 = setTimeout(nudgeResize, 50);
    const t2 = setTimeout(nudgeResize, 400);
    return () => {
      clearTimeout(t1);
      clearTimeout(t2);
    };
  }, [instance]);

  useEffect(() => {
    let revealed = false;

    function reveal() {
      if (revealed) return;
      revealed = true;
      settingsRef.current?.classList.add("avatar-app-ready");
      setIsAppReady(true);
    }

    function onProfileUpdate(e: Event) {
      const detail = (e as CustomEvent).detail;
      if (detail?.instance && detail.instance !== instance) return;
      reveal();
    }

    function onAppReady(e: Event) {
      const detail = (e as CustomEvent).detail;
      if (!detail?.instance || detail.instance === instance) reveal();
    }

    window.addEventListener("avatar:update-profile", onProfileUpdate);
    window.addEventListener("avatar:app:ready", onAppReady);

    const fallback = setTimeout(reveal, 3000);

    return () => {
      window.removeEventListener("avatar:update-profile", onProfileUpdate);
      window.removeEventListener("avatar:app:ready", onAppReady);
      clearTimeout(fallback);
    };
  }, [instance]);

  const languages = [
    {
      label: "English",
      styles:
        "text-blue-700 dark:text-blue-300 bg-blue-50 dark:bg-blue-950/40 border-blue-200 dark:border-blue-800/60",
    },
    {
      label: "Japanese",
      styles:
        "text-red-700 dark:text-red-300 bg-red-50 dark:bg-red-950/40 border-red-200 dark:border-red-800/60",
    },
    {
      label: "ENG + JP Bilingual",
      styles:
        "text-purple-700 dark:text-purple-300 bg-purple-50 dark:bg-purple-950/40 border-purple-200 dark:border-purple-800/60",
    },
  ];

  const lang = languages[cardIndex] || languages[2];

  return (
    <div className="relative bg-white dark:bg-paper-dim border border-line rounded-card overflow-hidden flex flex-col transition-all duration-200 ease-out hover:border-ai-indigo hover:-translate-y-1 hover:shadow-xl hover:shadow-ai-indigo-deep/5 dark:hover:shadow-black/40">
      <avatar-settings
        ref={settingsRef}
        key={instance}
        instance={instance}
        backend={BACKEND_URL}
        app-id={appId}
        settings-scope="app"
        settings-group={settingsGroup}
        className={`absolute top-2 right-2 z-10 ${
          process.env.NEXT_PUBLIC_SHOW_DEV_CONTROLS === "true" ? "" : "hidden"
        }`}
      />

      <Link
        href={`/practice/${scenarioId}/${avatarId}`}
        className="block no-underline text-inherit px-5 pt-5 pb-4 transition-colors duration-150 ease-out hover:bg-paper-dim/20 dark:hover:bg-white/5"
      >
        <div className="flex items-center gap-4 mb-3.5">
          <div className="relative w-18 h-18 rounded-full overflow-hidden bg-paper-dim ring-2 ring-line dark:ring-zinc-800 ring-offset-4 ring-offset-white dark:ring-offset-paper-dim flex shrink-0 items-center justify-center shadow-inner transition-all duration-200">
            {isSyncingData ? (
              <div className="absolute inset-0 bg-zinc-200 dark:bg-zinc-800 animate-pulse rounded-full" />
            ) : profile?.thumbnail ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img
                src={profile.thumbnail}
                alt={displayName}
                className="w-full h-full object-cover"
              />
            ) : (
              <div
                className="font-display text-[26px] font-bold text-ai-indigo transition-colors"
                aria-hidden="true"
              >
                {displayName.charAt(0).toUpperCase()}
              </div>
            )}
          </div>

          <div className="min-w-0 flex-1">
            {isSyncingData ? (
              <div className="space-y-2 animate-pulse">
                <div className="h-5 bg-zinc-200 dark:bg-zinc-800 rounded w-2/3" />
                <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-1/3" />
              </div>
            ) : (
              <>
                <h3 className="text-lg font-medium text-ai-indigo-deep m-0 transition-colors mb-1.5">
                  {displayName}
                </h3>

                <span
                  className={`inline-block text-[10px] font-extrabold tracking-wider uppercase border rounded-full px-2 py-0.5 transition-colors ${lang.styles}`}
                >
                  {lang.label}
                </span>
              </>
            )}
          </div>
        </div>

        <div className="min-h-10 flex flex-col justify-center">
          {isSyncingData ? (
            <div className="space-y-2 animate-pulse w-full">
              <div className="h-3.5 bg-zinc-200 dark:bg-zinc-800 rounded w-full" />
              <div className="h-3.5 bg-zinc-200 dark:bg-zinc-800 rounded w-5/6" />
            </div>
          ) : (
            <p className="text-[13px] leading-normal text-ink-soft m-0 transition-colors">
              {displayPersona}
            </p>
          )}
        </div>
      </Link>
    </div>
  );
}