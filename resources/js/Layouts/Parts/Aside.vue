<template>
    <aside class="sidenav navbar navbar-vertical navbar-expand-xs border-0 border-radius-xl my-3 fixed-left ms-3" id="sidenav-main">
        <div class="sidenav-header">
            <i class="fas fa-times p-3 cursor-pointer text-secondary opacity-5 position-absolute right-0 top-0 d-none d-xl-none" aria-hidden="true" id="iconSidenav"></i>
            <a class="navbar-brand m-0" href="/">
                <img src="/assets/img/logo.png" class="navbar-brand-img h-100 w-15" alt="...">
                <span class="ms-1 font-weight-bold text-uppercase">Cryptixel.art</span>
            </a>
        </div>
        <hr class="horizontal dark mt-0">
        <div class="collapse navbar-collapse  w-auto" id="sidenav-collapse-main">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" v-bind:class="{'active' : route().current('homepage')}" :href="route('homepage')">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fas fa-fire fa-xl" v-bind:style="[route().current('homepage') ? 'color:#fff;' : 'color:#863fff']"></i>
                        </div>
                        <span class="nav-link-text ms-1">Home</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" v-bind:class="{'active' : route().current('faq')}" :href="route('faq')">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fas fa-bookmark fa-xl" v-bind:style="[route().current('faq') ? 'color:#fff;' : 'color:#1874cb']"></i>
                        </div>
                        <span class="nav-link-text ms-1">FAQ</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" v-bind:class="{'active' : route().current('roadmap')}" :href="route('roadmap')">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fas fa-map fa-xl" v-bind:style="[route().current('roadmap') ? 'color:#fff;' : 'color:#dc0d0d']"></i>
                        </div>
                        <span class="nav-link-text ms-1" >Roadmap</span>
                    </a>
                </li>
                <li class="nav-item mt-3">
                    <h6 class="ps-4 ms-2 text-uppercase text-xs font-weight-bolder opacity-6">Links</h6>
                </li>
                <li class="nav-item">
                    <a class="nav-link" target="_blank" href="https://twitter.com/cryptixelart">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fab fa-twitter fa-xl" style="color: black"></i>
                        </div>
                        <span class="nav-link-text ms-1">Twitter</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" target="_blank" href="https://t.me/cryptixelart">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fab fa-telegram-plane fa-xl" style="color: black"></i>
                        </div>
                        <span class="nav-link-text ms-1">Telegram</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" target="_blank" href="https://opensea.io/CRYPTIXELART">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fas fa-ship fa-xl" style="color: black"></i>
                        </div>
                        <span class="nav-link-text ms-1">Opensea</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" target="_blank" href="https://www.linkedin.com/in/clint-de-battista/">
                        <div class="icon icon-shape icon-sm shadow border-radius-md bg-white text-center me-2 d-flex align-items-center justify-content-center">
                            <i class="fab fa-linkedin-in fa-xl" style="color: black"></i>
                        </div>
                        <span class="nav-link-text ms-1">Linkedin</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>
</template>
