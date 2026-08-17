[1mdiff --git a/components/AvatarComponents.tsx b/components/AvatarComponents.tsx[m
[1mindex 89a220e..eaef7cb 100644[m
[1m--- a/components/AvatarComponents.tsx[m
[1m+++ b/components/AvatarComponents.tsx[m
[36m@@ -54,8 +54,16 @@[m [mexport default function AvatarComponents({[m
         // eslint-disable-next-line no-console[m
         console.error("[AvatarComponents] failed to load avatar script:", error);[m
       });[m
[32m+[m
[32m+[m[32m    // Catches the mobile toolbar-settle race independent of avatar[m
[32m+[m[32m    // script load timing — forces next/image to re-evaluate `sizes`[m
[32m+[m[32m    // and the dvh-based containers to re-measure against the real[m
[32m+[m[32m    // viewport shortly after first paint.[m
[32m+[m[32m    const settleTimer = setTimeout(nudgeResize, 600);[m
[32m+[m
     return () => {[m
       cancelled = true;[m
[32m+[m[32m      clearTimeout(settleTimer);[m
     };[m
   }, []);[m
 [m
[36m@@ -156,12 +164,13 @@[m [mexport default function AvatarComponents({[m
         alt=""[m
         fill[m
         priority[m
[32m+[m[32m        quality={90}[m
         sizes="100vw"[m
[31m-        className="fixed inset-0 -z-20 object-cover object-bottom"[m
[32m+[m[32m        className="fixed inset-0 -z-20 h-dvh object-cover object-bottom"[m
       />[m
[31m-      <div className="fixed inset-0 -z-10 bg-black/25" />[m
[32m+[m[32m      <div className="fixed inset-0 -z-10 h-dvh bg-black/25" />[m
 [m
[31m-      <div className="fixed inset-0 z-0 flex flex-col overflow-hidden">[m
[32m+[m[32m      <div className="fixed inset-0 z-0 h-dvh flex flex-col overflow-hidden">[m
         <div className="flex-1 min-h-0 flex relative">[m
           {/* Overlay stays visible until the model reports ready OR a[m
               distinct failure state, instead of unconditionally[m
[1mdiff --git a/lib/config.ts b/lib/config.ts[m
[1mindex 39651bc..c449599 100644[m
[1m--- a/lib/config.ts[m
[1m+++ b/lib/config.ts[m
[36m@@ -5,7 +5,5 @@[m [mexport const AVATAR_SCRIPT_URL = "https://ai-avatar-ui-ghost.vercel.app/ai-avata[m
 [m
 export const APP_ID = "ai-dojo";[m
 [m
[31m-// The avatarId in the AI Avatar Team's roster (AvatarSources.js) that DOJO[m
[31m-// scenarios re-persona. If this is wrong, ask the AI Avatar Team for the[m
[31m-// correct id — everything else in the integration still works.[m
[32m+[m
 export const DOJO_AVATAR_ID = "japanese_roleplay";[m
[1mdiff --git a/package-lock.json b/package-lock.json[m
[1mindex 5e920db..508830c 100644[m
[1m--- a/package-lock.json[m
[1m+++ b/package-lock.json[m
[36m@@ -19,6 +19,8 @@[m
         "@types/node": "^20.14.0",[m
         "@types/react": "^18.3.3",[m
         "@types/react-dom": "^18.3.0",[m
[32m+[m[32m        "eslint": "^9",[m
[32m+[m[32m        "eslint-config-next": "^15.4.6",[m
         "typescript": "^5.5.4"[m
       }[m
     },[m
[36m@@ -34,6 +36,17 @@[m
         "url": "https://github.com/sponsors/sindresorhus"[m
       }[m
     },[m
[32m+[m[32m    "node_modules/@emnapi/core": {[m
[32m+[m[32m      "version": "1.10.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@emnapi/core/-/core-1.10.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-yq6OkJ4p82CAfPl0u9mQebQHKPJkY7WrIuk205cTYnYe+k2Z8YBh11FrbRG/H6ihirqcacOgl2BIO8oyMQLeXw==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@emnapi/wasi-threads": "1.2.1",[m
[32m+[m[32m        "tslib": "^2.4.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
     "node_modules/@emnapi/runtime": {[m
       "version": "1.11.3",[m
       "resolved": "https://registry.npmjs.org/@emnapi/runtime/-/runtime-1.11.3.tgz",[m
[36m@@ -44,6 +57,226 @@[m
         "tslib": "^2.4.0"[m
       }[m
     },[m
[32m+[m[32m    "node_modules/@emnapi/wasi-threads": {[m
[32m+[m[32m      "version": "1.2.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@emnapi/wasi-threads/-/wasi-threads-1.2.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-uTII7OYF+/Mes/MrcIOYp5yOtSMLBWSIoLPpcgwipoiKbli6k322tcoFsxoIIxPDqW01SQGAgko4EzZi2BNv2w==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "tslib": "^2.4.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint-community/eslint-utils": {[m
[32m+[m[32m      "version": "4.10.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.10.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-cuadcxVFE8sDK6iWJbs8Sn0av2Nrh2QSGQhVlBW9AaAHqHwjWsZHT8LJ4hFGPh7ASBV2deFdM7H/DPjulmh8rg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "eslint-visitor-keys": "^3.4.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://opencollective.com/eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "eslint": "^6.0.0 || ^7.0.0 || >=8.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint-community/eslint-utils/node_modules/eslint-visitor-keys": {[m
[32m+[m[32m      "version": "3.4.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-wpc+LXeiyiisxPlEkUzU6svyS1frIO3Mgxj1fdy7Pm8Ygzguax2N3Fa/D/ag1WqbOprdI+uY6wMUl8/a2G+iag==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://opencollective.com/eslint"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint-community/regexpp": {[m
[32m+[m[32m      "version": "4.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-EriSTlt5OC9/7SXkRSCAhfSxxoSUgBm33OH+IkwbdpgoqsSsUg7y3uh+IICI/Qg4BBWr3U2i39RpmycbxMq4ew==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^12.0.0 || ^14.0.0 || >=16.0.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/config-array": {[m
[32m+[m[32m      "version": "0.21.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/config-array/-/config-array-0.21.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-nJl2KGTlrf9GjLimgIru+V/mzgSK0ABCDQRvxw5BjURL7WfH5uoWmizbH7QB6MmnMBd8cIC9uceWnezL1VZWWw==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@eslint/object-schema": "^2.1.7",[m
[32m+[m[32m        "debug": "^4.3.1",[m
[32m+[m[32m        "minimatch": "^3.1.5"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/config-helpers": {[m
[32m+[m[32m      "version": "0.4.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/config-helpers/-/config-helpers-0.4.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-gBrxN88gOIf3R7ja5K9slwNayVcZgK6SOUORm2uBzTeIEfeVaIhOpCtTox3P6R7o2jLFwLFTLnC7kU/RGcYEgw==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@eslint/core": "^0.17.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/core": {[m
[32m+[m[32m      "version": "0.17.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/core/-/core-0.17.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-yL/sLrpmtDaFEiUj1osRP4TI2MDz1AddJL+jZ7KSqvBuliN4xqYY54IfdN8qD8Toa6g1iloph1fxQNkjOxrrpQ==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@types/json-schema": "^7.0.15"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/eslintrc": {[m
[32m+[m[32m      "version": "3.3.6",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-3.3.6.tgz",[m
[32m+[m[32m      "integrity": "sha512-l2Ul9PrHsPCKcEY/ac7VgFj9D80C7S68sOKc618SyHDPK36s1XcFebXY0iTzUVn4Yq+YbwvSnDmCz9yxjX+QrA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "ajv": "^6.14.0",[m
[32m+[m[32m        "debug": "^4.3.2",[m
[32m+[m[32m        "espree": "^10.0.1",[m
[32m+[m[32m        "globals": "^14.0.0",[m
[32m+[m[32m        "ignore": "^5.2.0",[m
[32m+[m[32m        "import-fresh": "^3.2.1",[m
[32m+[m[32m        "js-yaml": "^4.3.0",[m
[32m+[m[32m        "minimatch": "^3.1.5",[m
[32m+[m[32m        "strip-json-comments": "^3.1.1"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://opencollective.com/eslint"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/js": {[m
[32m+[m[32m      "version": "9.39.5",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/js/-/js-9.39.5.tgz",[m
[32m+[m[32m      "integrity": "sha512-QywQuszQh77pIXCsq998c8hbhSTI/azTty1Z6N53dmAudKHhy573j3yvRLsX2BSp8YpLtoCEG8E9DJe+8zUh4A==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://eslint.org/donate"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/object-schema": {[m
[32m+[m[32m      "version": "2.1.7",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/object-schema/-/object-schema-2.1.7.tgz",[m
[32m+[m[32m      "integrity": "sha512-VtAOaymWVfZcmZbp6E2mympDIHvyjXs/12LqWYjVw6qjrfF+VK+fyG33kChz3nnK+SU5/NeHOqrTEHS8sXO3OA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@eslint/plugin-kit": {[m
[32m+[m[32m      "version": "0.4.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@eslint/plugin-kit/-/plugin-kit-0.4.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-43/qtrDUokr7LJqoF2c3+RInu/t4zfrpYdoSDfYyhg52rwLV6TnOvdG4fXm7IkSB3wErkcmJS9iEhjVtOSEjjA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@eslint/core": "^0.17.0",[m
[32m+[m[32m        "levn": "^0.4.1"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@humanfs/core": {[m
[32m+[m[32m      "version": "0.19.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@humanfs/core/-/core-0.19.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-UhXNm+CFMWcbChXywFwkmhqjs3PRCmcSa/hfBgLIb7oQ5HNb1wS0icWsGtSAUNgefHeI+eBrA8I1fxmbHsGdvA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@humanfs/types": "^0.15.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=18.18.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@humanfs/node": {[m
[32m+[m[32m      "version": "0.16.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@humanfs/node/-/node-0.16.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-gE1eQNZ3R++kTzFUpdGlpmy8kDZD/MLyHqDwqjkVQI0JMdI1D51sy1H958PNXYkM2rAac7e5/CnIKZrHtPh3BQ==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@humanfs/core": "^0.19.2",[m
[32m+[m[32m        "@humanfs/types": "^0.15.0",[m
[32m+[m[32m        "@humanwhocodes/retry": "^0.4.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=18.18.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@humanfs/types": {[m
[32m+[m[32m      "version": "0.15.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@humanfs/types/-/types-0.15.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-ZZ1w0aoQkwuUuC7Yf+7sdeaNfqQiiLcSRbfI08oAxqLtpXQr9AIVX7Ay7HLDuiLYAaFPu8oBYNq/QIi9URHJ3Q==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=18.18.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@humanwhocodes/module-importer": {[m
[32m+[m[32m      "version": "1.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-bxveV4V8v5Yb4ncFTT3rPSgZBOpCkjfK0y4oVVVJwIuDVBRMDXrPyXRL988i5ap9m9bnyEEjWfm5WkBmtffLfA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=12.22"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "github",[m
[32m+[m[32m        "url": "https://github.com/sponsors/nzakas"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@humanwhocodes/retry": {[m
[32m+[m[32m      "version": "0.4.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@humanwhocodes/retry/-/retry-0.4.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-bV0Tgo9K4hfPCek+aMAn81RppFKv2ySDQeMoSZuvTASywNTnVJCArCZE2FWqpvIatKu7VMRLWlR1EazvVhDyhQ==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=18.18"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "github",[m
[32m+[m[32m        "url": "https://github.com/sponsors/nzakas"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
     "node_modules/@img/colour": {[m
       "version": "1.1.0",[m
       "resolved": "https://registry.npmjs.org/@img/colour/-/colour-1.1.0.tgz",[m
[36m@@ -555,12 +788,43 @@[m
         "@jridgewell/sourcemap-codec": "^1.4.14"[m
       }[m
     },[m
[32m+[m[32m    "node_modules/@napi-rs/wasm-runtime": {[m
[32m+[m[32m      "version": "1.2.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@napi-rs/wasm-runtime/-/wasm-runtime-1.2.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-UMduMbqO5s5zF2NkNacMT/yK5Y5QiKvWr2+50bzIIxFDwVJ2h49b+oyjaCGPhJxd2/gC2x39EHv/gHVuu36x2Q==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@tybys/wasm-util": "^0.10.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || ^22.13.0 || >=23.5.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "github",[m
[32m+[m[32m        "url": "https://github.com/sponsors/Brooooooklyn"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "@emnapi/core": "^1.7.1 || ^2.0.0-alpha.4",[m
[32m+[m[32m        "@emnapi/runtime": "^1.7.1 || ^2.0.0-alpha.4"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
     "node_modules/@next/env": {[m
       "version": "15.5.23",[m
       "resolved": "https://registry.npmjs.org/@next/env/-/env-15.5.23.tgz",[m
       "integrity": "sha512-Mv3Z9hVbFcPnoLevsZ6rnX1TBtyHb5E17yN7HTPDXSXxeNsGBjUFrdbjRXKKXIOhfth7/cg6Ay7PZ2UFawaWsQ==",[m
       "license": "MIT"[m
     },[m
[32m+[m[32m    "node_modules/@next/eslint-plugin-next": {[m
[32m+[m[32m      "version": "15.5.23",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@next/eslint-plugin-next/-/eslint-plugin-next-15.5.23.tgz",[m
[32m+[m[32m      "integrity": "sha512-0KnCFpiWVIsbwBhByZ0uIcjYM5xqGrFzN2eOPbwru/wuy5Z1dmA+3gP+PRbi4gl1Ny7an66BqAM/NHkX/50rbw==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "fast-glob": "3.3.1"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
     "node_modules/@next/swc-darwin-arm64": {[m
       "version": "15.5.23",[m
       "resolved": "https://registry.npmjs.org/@next/swc-darwin-arm64/-/swc-darwin-arm64-15.5.23.tgz",[m
[36m@@ -689,6 +953,68 @@[m
         "node": ">= 10"[m
       }[m
     },[m
[32m+[m[32m    "node_modules/@nodelib/fs.scandir": {[m
[32m+[m[32m      "version": "2.1.5",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz",[m
[32m+[m[32m      "integrity": "sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@nodelib/fs.stat": "2.0.5",[m
[32m+[m[32m        "run-parallel": "^1.1.9"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@nodelib/fs.stat": {[m
[32m+[m[32m      "version": "2.0.5",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz",[m
[32m+[m[32m      "integrity": "sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@nodelib/fs.walk": {[m
[32m+[m[32m      "version": "1.2.8",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz",[m
[32m+[m[32m      "integrity": "sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@nodelib/fs.scandir": "2.1.5",[m
[32m+[m[32m        "fastq": "^1.6.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">= 8"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@nolyfill/is-core-module": {[m
[32m+[m[32m      "version": "1.0.39",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@nolyfill/is-core-module/-/is-core-module-1.0.39.tgz",[m
[32m+[m[32m      "integrity": "sha512-nn5ozdjYQpUCZlWGuxcJY/KpxkWQs4DcbMCmKojjyrYDEAGy4Ce19NN4v5MduafTwJlbKc99UA8YhSVqq9yPZA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": ">=12.4.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rtsao/scc": {[m
[32m+[m[32m      "version": "1.1.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rtsao/scc/-/scc-1.1.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-zt6OdqaDoOnJ1ZYsCYGt9YmWzDXl4vQdKTyJev62gFhRGKdx7mcT54V9KIjg+d2wi9EXsPvAPKe7i7WjfVWB8g==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@rushstack/eslint-patch": {[m
[32m+[m[32m      "version": "1.16.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@rushstack/eslint-patch/-/eslint-patch-1.16.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-TvZbIpeKqGQQ7X0zSCvPH9riMSFQFSggnfBjFZ1mEoILW+UuXCKwOoPcgjMwiUtRqFZ8jWhPJc4um14vC6I4ag==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
     "node_modules/@swc/helpers": {[m
       "version": "0.5.15",[m
       "resolved": "https://registry.npmjs.org/@swc/helpers/-/helpers-0.5.15.tgz",[m
[36m@@ -966,6 +1292,37 @@[m
         "tailwindcss": "4.3.3"[m
       }[m
     },[m
[32m+[m[32m    "node_modules/@tybys/wasm-util": {[m
[32m+[m[32m      "version": "0.10.3",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@tybys/wasm-util/-/wasm-util-0.10.3.tgz",[m
[32m+[m[32m      "integrity": "sha512-F3fo1MYrRJYL3zER0OUOmkutjr1Vp23m7OsSgp7nq4SP6OqX6C/56XFIPAl5bt3zaBRjmW7SGz3u/6LwFpYcOg==",[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "tslib": "^2.4.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@types/estree": {[m
[32m+[m[32m      "version": "1.0.9",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@types/estree/-/estree-1.0.9.tgz",[m
[32m+[m[32m      "integrity": "sha512-GhdPgy1el4/ImP05X05Uw4cw2/M93BCUmnEvWZNStlCzEKME4Fkk+YpoA5OiHNQmoS7Cafb8Xa3Pya8m1Qrzeg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@types/json-schema": {[m
[32m+[m[32m      "version": "7.0.15",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz",[m
[32m+[m[32m      "integrity": "sha512-5+fP8P8MFNC+AyZCDxrB2pkZFPGzqQWUzpSeuuVLvm8VMcorNYavBqoFcxK8bQz4Qsbn4oUEEem4wDLfcysGHA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@types/json5": {[m
[32m+[m[32m      "version": "0.0.29",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@types/json5/-/json5-0.0.29.tgz",[m
[32m+[m[32m      "integrity": "sha512-dRLjCWHYg4oaA77cxO64oO+7JwCwnIzkZPdrrC71jQmQtlhM556pwKo5bUzqvZndkVbeFLIIi+9TC40JNF5hNQ==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT"[m
[32m+[m[32m    },[m
     "node_modules/@types/node": {[m
       "version": "20.19.43",[m
       "resolved": "https://registry.npmjs.org/@types/node/-/node-20.19.43.tgz",[m
[36m@@ -1004,595 +1361,4415 @@[m
         "@types/react": "^18.0.0"[m
       }[m
     },[m
[31m-    "node_modules/caniuse-lite": {[m
[31m-      "version": "1.0.30001809",[m
[31m-      "resolved": "https://registry.npmjs.org/caniuse-lite/-/caniuse-lite-1.0.30001809.tgz",[m
[31m-      "integrity": "sha512-xxWVywk6a6Arlk+hymeycyn/VgqEfLDxupvhH/xiY5SJ/18kmi9o6MiO320DCUzypORHLtvh0I4i04tUhCNHNQ==",[m
[31m-      "funding": [[m
[31m-        {[m
[31m-          "type": "opencollective",[m
[31m-          "url": "https://opencollective.com/browserslist"[m
[31m-        },[m
[31m-        {[m
[31m-          "type": "tidelift",[m
[31m-          "url": "https://tidelift.com/funding/github/npm/caniuse-lite"[m
[31m-        },[m
[31m-        {[m
[31m-          "type": "github",[m
[31m-          "url": "https://github.com/sponsors/ai"[m
[31m-        }[m
[31m-      ],[m
[31m-      "license": "CC-BY-4.0"[m
[31m-    },[m
[31m-    "node_modules/client-only": {[m
[31m-      "version": "0.0.1",[m
[31m-      "resolved": "https://registry.npmjs.org/client-only/-/client-only-0.0.1.tgz",[m
[31m-      "integrity": "sha512-IV3Ou0jSMzZrd3pZ48nLkT9DA7Ag1pnPzaiQhpW7c3RbcqqzvzzVu+L8gfqMp/8IM2MQtSiqaCxrrcfu8I8rMA==",[m
[31m-      "license": "MIT"[m
[31m-    },[m
[31m-    "node_modules/csstype": {[m
[31m-      "version": "3.2.3",[m
[31m-      "resolved": "https://registry.npmjs.org/csstype/-/csstype-3.2.3.tgz",[m
[31m-      "integrity": "sha512-z1HGKcYy2xA8AGQfwrn0PAy+PB7X/GSj3UVJW9qKyn43xWa+gl5nXmU4qqLMRzWVLFC8KusUX8T/0kCiOYpAIQ==",[m
[32m+[m[32m    "node_modules/@typescript-eslint/eslint-plugin": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-Un7Heoyj65NREbKAyIrFxeM143NZpExWmy1Nep4DLeQOeLlTeumPjoNKnBrU5D5moWXbPJgRa5Uwcdu0faVNGQ==",[m
       "dev": true,[m
[31m-      "license": "MIT"[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@eslint-community/regexpp": "^4.12.2",[m
[32m+[m[32m        "@typescript-eslint/scope-manager": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/type-utils": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/utils": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/visitor-keys": "8.67.0",[m
[32m+[m[32m        "ignore": "^7.0.5",[m
[32m+[m[32m        "natural-compare": "^1.4.0",[m
[32m+[m[32m        "ts-api-utils": "^2.5.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "@typescript-eslint/parser": "^8.67.0",[m
[32m+[m[32m        "eslint": "^8.57.0 || ^9.0.0 || ^10.0.0",[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
[32m+[m[32m      }[m
     },[m
[31m-    "node_modules/detect-libc": {[m
[31m-      "version": "2.1.2",[m
[31m-      "resolved": "https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz",[m
[31m-      "integrity": "sha512-Btj2BOOO83o3WyH59e8MgXsxEQVcarkUOpEYrubB0urwnN10yQ364rsiByU11nZlqWYZm05i/of7io4mzihBtQ==",[m
[31m-      "license": "Apache-2.0",[m
[32m+[m[32m    "node_modules/@typescript-eslint/eslint-plugin/node_modules/ignore": {[m
[32m+[m[32m      "version": "7.0.6",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/ignore/-/ignore-7.0.6.tgz",[m
[32m+[m[32m      "integrity": "sha512-BAg6QkE8W+TuQLrrw0Ugr7HegXduRuuj8/ti2kSOc+jz1dmx8/WNcjr6XGnq5YpDWxFwwaavqD0+jIUOKelTsw==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "engines": {[m
[31m-        "node": ">=8"[m
[32m+[m[32m        "node": ">= 4"[m
       }[m
     },[m
[31m-    "node_modules/enhanced-resolve": {[m
[31m-      "version": "5.24.5",[m
[31m-      "resolved": "https://registry.npmjs.org/enhanced-resolve/-/enhanced-resolve-5.24.5.tgz",[m
[31m-      "integrity": "sha512-L1l8TNvomm6UVW5B253AGxQagSQr+vGwhMlrrfRS2qmhx46AMpMVJKQYLvWYbysTMY8VoicOvzHzoHMbyzB+4A==",[m
[32m+[m[32m    "node_modules/@typescript-eslint/parser": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/parser/-/parser-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-fUBfTuuEulWqX6V8+O3PtScV01tzYYRUDTAirHFKoRAt7nOzoGiPt0M/bB47wWNy0coOOcgEwAMUtBpykMxl6w==",[m
[32m+[m[32m      "dev": true,[m
       "license": "MIT",[m
       "dependencies": {[m
[31m-        "graceful-fs": "^4.2.4",[m
[31m-        "tapable": "^2.3.3"[m
[32m+[m[32m        "@typescript-eslint/scope-manager": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/types": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/typescript-estree": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/visitor-keys": "8.67.0",[m
[32m+[m[32m        "debug": "^4.4.3"[m
       },[m
       "engines": {[m
[31m-        "node": ">=10.13.0"[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "eslint": "^8.57.0 || ^9.0.0 || ^10.0.0",[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
       }[m
     },[m
[31m-    "node_modules/graceful-fs": {[m
[31m-      "version": "4.2.11",[m
[31m-      "resolved": "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.11.tgz",[m
[31m-      "integrity": "sha512-RbJ5/jmFcNNCcDV5o9eTnBLJ/HszWV0P73bc+Ff4nS/rJj+YaS6IGyiOL0VoBYX+l1Wrl3k63h/KrH+nhJ0XvQ==",[m
[31m-      "license": "ISC"[m
[31m-    },[m
[31m-    "node_modules/jiti": {[m
[31m-      "version": "2.7.0",[m
[31m-      "resolved": "https://registry.npmjs.org/jiti/-/jiti-2.7.0.tgz",[m
[31m-      "integrity": "sha512-AC/7JofJvZGrrneWNaEnJeOLUx+JlGt7tNa0wZiRPT4MY1wmfKjt2+6O2p2uz2+skll8OZZmJMNqeke7kKbNgQ==",[m
[32m+[m[32m    "node_modules/@typescript-eslint/project-service": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/project-service/-/project-service-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-cvE8c7ulYeXN9fYuszhCeCsbzyVEXuhrRCybnBre7TUmqb5nRmBfQAwCj0O3WJFDeyAZt4VYv51vMCC9LHSdYw==",[m
[32m+[m[32m      "dev": true,[m
       "license": "MIT",[m
[31m-      "bin": {[m
[31m-        "jiti": "lib/jiti-cli.mjs"[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@typescript-eslint/tsconfig-utils": "^8.67.0",[m
[32m+[m[32m        "@typescript-eslint/types": "^8.67.0",[m
[32m+[m[32m        "debug": "^4.4.3"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
       }[m
     },[m
[31m-    "node_modules/js-tokens": {[m
[31m-      "version": "4.0.0",[m
[31m-      "resolved": "https://registry.npmjs.org/js-tokens/-/js-tokens-4.0.0.tgz",[m
[31m-      "integrity": "sha512-RdJUflcE3cUzKiMqQgsCu06FPu9UdIJO0beYbPhHN4k6apgJtifcoCtT9bcxOpYBtpD2kCM6Sbzg4CausW/PKQ==",[m
[31m-      "license": "MIT"[m
[32m+[m[32m    "node_modules/@typescript-eslint/scope-manager": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-EgvsleTwS4E+WzzSvem8fAUubLwatMNF1B5hHSLQxcvs7q2dtRhGyujHwLJSYlG41niJ7GP24Aha2+0mb1b2kg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@typescript-eslint/types": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/visitor-keys": "8.67.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      }[m
     },[m
[31m-    "node_modules/lightningcss": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss/-/lightningcss-1.32.0.tgz",[m
[31m-      "integrity": "sha512-NXYBzinNrblfraPGyrbPoD19C1h9lfI/1mzgWYvXUTe414Gz/X1FD2XBZSZM7rRTrMA8JL3OtAaGifrIKhQ5yQ==",[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m    "node_modules/@typescript-eslint/tsconfig-utils": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/tsconfig-utils/-/tsconfig-utils-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-vV+LUSv5njUWsknE71fqKTlXUva+R76SaeORd6Zojcunk/6DvKFXONU3BrAs2H49mbygUXt6gbYunzwqNwlhdg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/type-utils": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-aVWDXbRmdXO9siTfX4ditQI1T9+zVcNazT48EJCD0v40/9RIFoUgZ05CmGEq9H2gixRpjUn/iplwvlcvutJW/Q==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "dependencies": {[m
[31m-        "detect-libc": "^2.0.3"[m
[32m+[m[32m        "@typescript-eslint/types": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/typescript-estree": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/utils": "8.67.0",[m
[32m+[m[32m        "debug": "^4.4.3",[m
[32m+[m[32m        "ts-api-utils": "^2.5.0"[m
       },[m
       "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
       },[m
       "funding": {[m
         "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
       },[m
[31m-      "optionalDependencies": {[m
[31m-        "lightningcss-android-arm64": "1.32.0",[m
[31m-        "lightningcss-darwin-arm64": "1.32.0",[m
[31m-        "lightningcss-darwin-x64": "1.32.0",[m
[31m-        "lightningcss-freebsd-x64": "1.32.0",[m
[31m-        "lightningcss-linux-arm-gnueabihf": "1.32.0",[m
[31m-        "lightningcss-linux-arm64-gnu": "1.32.0",[m
[31m-        "lightningcss-linux-arm64-musl": "1.32.0",[m
[31m-        "lightningcss-linux-x64-gnu": "1.32.0",[m
[31m-        "lightningcss-linux-x64-musl": "1.32.0",[m
[31m-        "lightningcss-win32-arm64-msvc": "1.32.0",[m
[31m-        "lightningcss-win32-x64-msvc": "1.32.0"[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "eslint": "^8.57.0 || ^9.0.0 || ^10.0.0",[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
       }[m
     },[m
[31m-    "node_modules/lightningcss-android-arm64": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-android-arm64/-/lightningcss-android-arm64-1.32.0.tgz",[m
[31m-      "integrity": "sha512-YK7/ClTt4kAK0vo6w3X+Pnm0D2cf2vPHbhOXdoNti1Ga0al1P4TBZhwjATvjNwLEBCnKvjJc2jQgHXH0NEwlAg==",[m
[32m+[m[32m    "node_modules/@typescript-eslint/types": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/types/-/types-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-sBtgslww8nsMYUjhdPBiSyUqSzT8uR6g93A2QXnQC8+cGdjz0CyaOdqHDRJb1AtORbZCNUJBBeFA/tNR2uQmww==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/typescript-estree": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-EKQBCE9yNlRJYm7jdTW5AhDacDUmSwQb0FAJAmK2EKYrNXIsa2vxcSZx6PvJ/dEdI6lS+Y9W+EXckLj0iPFGcw==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@typescript-eslint/project-service": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/tsconfig-utils": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/types": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/visitor-keys": "8.67.0",[m
[32m+[m[32m        "debug": "^4.4.3",[m
[32m+[m[32m        "minimatch": "^10.2.2",[m
[32m+[m[32m        "semver": "^7.7.3",[m
[32m+[m[32m        "tinyglobby": "^0.2.15",[m
[32m+[m[32m        "ts-api-utils": "^2.5.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/typescript-estree/node_modules/balanced-match": {[m
[32m+[m[32m      "version": "4.0.4",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/balanced-match/-/balanced-match-4.0.4.tgz",[m
[32m+[m[32m      "integrity": "sha512-BLrgEcRTwX2o6gGxGOCNyMvGSp35YofuYzw9h1IMTRmKqttAZZVU67bdb9Pr2vUHA8+j3i2tJfjO6C6+4myGTA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "18 || 20 || >=22"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/typescript-estree/node_modules/brace-expansion": {[m
[32m+[m[32m      "version": "5.0.9",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-5.0.9.tgz",[m
[32m+[m[32m      "integrity": "sha512-ScQ4IuvIEF1TMlP7Zt+vjJ//9zlPb2SDcxWxM3bk8s6t6GGdJ7KO1dCcTidOPJKePW30LE/2cT7wCyPho9/Wxg==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "balanced-match": "^4.0.2"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "20 || >=22"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/typescript-estree/node_modules/minimatch": {[m
[32m+[m[32m      "version": "10.2.6",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-10.2.6.tgz",[m
[32m+[m[32m      "integrity": "sha512-vpLQEs+VLCr1nU0BXS07maYoFwlDAH0gngQuuttxIwutDFEMHq2blX+8vpgxDdK3J1PwjCJiep77OitTZ4Ll1A==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "BlueOak-1.0.0",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "brace-expansion": "^5.0.8"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "18 || 20 || >=22"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://github.com/sponsors/isaacs"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/utils": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/utils/-/utils-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-U9D1FdwEWBwok3hxxSdhclMb0twvt9QnjIQ0VfQ1AiX2epnpSgv2ubVDsayOFyY8K6FX+AQ7E0FKWVG3iKsj1A==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@eslint-community/eslint-utils": "^4.9.1",[m
[32m+[m[32m        "@typescript-eslint/scope-manager": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/types": "8.67.0",[m
[32m+[m[32m        "@typescript-eslint/typescript-estree": "8.67.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      },[m
[32m+[m[32m      "peerDependencies": {[m
[32m+[m[32m        "eslint": "^8.57.0 || ^9.0.0 || ^10.0.0",[m
[32m+[m[32m        "typescript": ">=4.8.4 <6.1.0"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/visitor-keys": {[m
[32m+[m[32m      "version": "8.67.0",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-8.67.0.tgz",[m
[32m+[m[32m      "integrity": "sha512-fkv8dHRDqfGtTHuJeebdrQ7cX6Ad4WAS00rgHh9UGvMycF1mjBfsxry1XsLIFhWZ6Judlh6UdzK+TYlbpCXgnA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "dependencies": {[m
[32m+[m[32m        "@typescript-eslint/types": "8.67.0",[m
[32m+[m[32m        "eslint-visitor-keys": "^5.0.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^18.18.0 || ^20.9.0 || >=21.1.0"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "type": "opencollective",[m
[32m+[m[32m        "url": "https://opencollective.com/typescript-eslint"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@typescript-eslint/visitor-keys/node_modules/eslint-visitor-keys": {[m
[32m+[m[32m      "version": "5.0.1",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-5.0.1.tgz",[m
[32m+[m[32m      "integrity": "sha512-tD40eHxA35h0PEIZNeIjkHoDR4YjjJp34biM0mDvplBe//mB+IHCqHDGV7pxF+7MklTvighcCPPZC7ynWyjdTA==",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "Apache-2.0",[m
[32m+[m[32m      "engines": {[m
[32m+[m[32m        "node": "^20.19.0 || ^22.13.0 || >=24"[m
[32m+[m[32m      },[m
[32m+[m[32m      "funding": {[m
[32m+[m[32m        "url": "https://opencollective.com/eslint"[m
[32m+[m[32m      }[m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-android-arm-eabi": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-android-arm-eabi/-/resolver-binding-android-arm-eabi-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-g5T90pqg1bo/7mytQx6F4iBNC0Wsh9cu+z9veDbFjc7HjpesJFWD7QMS0NGStXM075+7dJPPVvBbpZlnrdpi/w==",[m
       "cpu": [[m
[31m-        "arm64"[m
[32m+[m[32m        "arm"[m
       ],[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "optional": true,[m
       "os": [[m
         "android"[m
[32m+[m[32m      ][m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-android-arm64": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-android-arm64/-/resolver-binding-android-arm64-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-YGCRZv/9GLhwmz6mYDeTsm/92BAyR28l6c2ReweVW5pWgfsitWLY8upvfRlGdoyD8HjeTHSYJWyZGD4KJA/nFQ==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm64"[m
       ],[m
[31m-      "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[31m-      },[m
[31m-      "funding": {[m
[31m-        "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[31m-      }[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "android"[m
[32m+[m[32m      ][m
     },[m
[31m-    "node_modules/lightningcss-darwin-arm64": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-darwin-arm64/-/lightningcss-darwin-arm64-1.32.0.tgz",[m
[31m-      "integrity": "sha512-RzeG9Ju5bag2Bv1/lwlVJvBE3q6TtXskdZLLCyfg5pt+HLz9BqlICO7LZM7VHNTTn/5PRhHFBSjk5lc4cmscPQ==",[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-darwin-arm64": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-darwin-arm64/-/resolver-binding-darwin-arm64-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-u9DiNT1auQMO20A9SyTuG3wUgQWB9Z7KjAg0uFuCDR1FsAY8A0CG2S6JpHS1xwm/w1G08bjXZDcyOCjv1WAm2w==",[m
       "cpu": [[m
         "arm64"[m
       ],[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "optional": true,[m
       "os": [[m
         "darwin"[m
[31m-      ],[m
[31m-      "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[31m-      },[m
[31m-      "funding": {[m
[31m-        "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[31m-      }[m
[32m+[m[32m      ][m
     },[m
[31m-    "node_modules/lightningcss-darwin-x64": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-darwin-x64/-/lightningcss-darwin-x64-1.32.0.tgz",[m
[31m-      "integrity": "sha512-U+QsBp2m/s2wqpUYT/6wnlagdZbtZdndSmut/NJqlCcMLTWp5muCrID+K5UJ6jqD2BFshejCYXniPDbNh73V8w==",[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-darwin-x64": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-darwin-x64/-/resolver-binding-darwin-x64-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-f7rPLi/T1HVKZu/u6t87lroib16n8vrSzcyxI7lg4BGO9UF26KhQL44sd9eOUgrTYhvRXtWOIZT5PejdPyJfUA==",[m
       "cpu": [[m
         "x64"[m
       ],[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "optional": true,[m
       "os": [[m
         "darwin"[m
[31m-      ],[m
[31m-      "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[31m-      },[m
[31m-      "funding": {[m
[31m-        "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[31m-      }[m
[32m+[m[32m      ][m
     },[m
[31m-    "node_modules/lightningcss-freebsd-x64": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-freebsd-x64/-/lightningcss-freebsd-x64-1.32.0.tgz",[m
[31m-      "integrity": "sha512-JCTigedEksZk3tHTTthnMdVfGf61Fky8Ji2E4YjUTEQX14xiy/lTzXnu1vwiZe3bYe0q+SpsSH/CTeDXK6WHig==",[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-freebsd-x64": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-freebsd-x64/-/resolver-binding-freebsd-x64-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-BpcOjWCJub6nRZUS2zA20pmLvjtqAtGejETaIyRLiZiQf++cbrjltLA5NN/xaXfqeOBOSlMFbemIl5/S5tljmg==",[m
       "cpu": [[m
         "x64"[m
       ],[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "optional": true,[m
       "os": [[m
         "freebsd"[m
[31m-      ],[m
[31m-      "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[31m-      },[m
[31m-      "funding": {[m
[31m-        "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[31m-      }[m
[32m+[m[32m      ][m
     },[m
[31m-    "node_modules/lightningcss-linux-arm-gnueabihf": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm-gnueabihf/-/lightningcss-linux-arm-gnueabihf-1.32.0.tgz",[m
[31m-      "integrity": "sha512-x6rnnpRa2GL0zQOkt6rts3YDPzduLpWvwAF6EMhXFVZXD4tPrBkEFqzGowzCsIWsPjqSK+tyNEODUBXeeVHSkw==",[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-linux-arm-gnueabihf": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-linux-arm-gnueabihf/-/resolver-binding-linux-arm-gnueabihf-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-vZTDvdSISZjJx66OzJqtsOhzifbqRjbmI1Mnu49fQDwog5GtDI4QidRiEAYbZCRj9C8YZEW+3ZjqsyS9GR4k2A==",[m
       "cpu": [[m
         "arm"[m
       ],[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
       "optional": true,[m
       "os": [[m
         "linux"[m
[32m+[m[32m      ][m
[32m+[m[32m    },[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-linux-arm-musleabihf": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-linux-arm-musleabihf/-/resolver-binding-linux-arm-musleabihf-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-BiPI+IrIlwcW4nLLMM21+B1dFPzd55yAVgVGrdgDjNef+ch03GdxrcyaIz8X9SsQirh/kCQ7mviyWlMxdh2D7g==",[m
[32m+[m[32m      "cpu": [[m
[32m+[m[32m        "arm"[m
       ],[m
[31m-      "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[31m-      },[m
[31m-      "funding": {[m
[31m-        "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[31m-      }[m
[32m+[m[32m      "dev": true,[m
[32m+[m[32m      "license": "MIT",[m
[32m+[m[32m      "optional": true,[m
[32m+[m[32m      "os": [[m
[32m+[m[32m        "linux"[m
[32m+[m[32m      ][m
     },[m
[31m-    "node_modules/lightningcss-linux-arm64-gnu": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-gnu/-/lightningcss-linux-arm64-gnu-1.32.0.tgz",[m
[31m-      "integrity": "sha512-0nnMyoyOLRJXfbMOilaSRcLH3Jw5z9HDNGfT/gwCPgaDjnx0i8w7vBzFLFR1f6CMLKF8gVbebmkUN3fa/kQJpQ==",[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-linux-arm64-gnu": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npmjs.org/@unrs/resolver-binding-linux-arm64-gnu/-/resolver-binding-linux-arm64-gnu-1.12.2.tgz",[m
[32m+[m[32m      "integrity": "sha512-zJc0H99FEPoFfSrNpa91HYfxzfAJCr502oxNK1cfdC9hlaFI43RT+JFCann9JUgZmLzzntChHyn13Sgn9ljHNg==",[m
       "cpu": [[m
         "arm64"[m
       ],[m
[32m+[m[32m      "dev": true,[m
       "libc": [[m
         "glibc"[m
       ],[m
[31m-      "license": "MPL-2.0",[m
[32m+[m[32m      "license": "MIT",[m
       "optional": true,[m
       "os": [[m
         "linux"[m
[31m-      ],[m
[31m-      "engines": {[m
[31m-        "node": ">= 12.0.0"[m
[31m-      },[m
[31m-      "funding": {[m
[31m-        "type": "opencollective",[m
[31m-        "url": "https://opencollective.com/parcel"[m
[31m-      }[m
[32m+[m[32m      ][m
     },[m
[31m-    "node_modules/lightningcss-linux-arm64-musl": {[m
[31m-      "version": "1.32.0",[m
[31m-      "resolved": "https://registry.npmjs.org/lightningcss-linux-arm64-musl/-/lightningcss-linux-arm64-musl-1.32.0.tgz",[m
[31m-      "integrity": "sha512-UpQkoenr4UJEzgVIYpI80lDFvRmPVg6oqboNHfoH4CQIfNA+HOrZ7Mo7KZP02dC6LjghPQJeBsvXhJod/wnIBg==",[m
[32m+[m[32m    "node_modules/@unrs/resolver-binding-linux-arm64-musl": {[m
[32m+[m[32m      "version": "1.12.2",[m
[32m+[m[32m      "resolved": "https://registry.npm