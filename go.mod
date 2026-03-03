module github.com/example/gh-app2

go 1.17

// SCA - Go modules with known critical/high vulnerabilities
require (
    github.com/gin-gonic/gin v1.6.3                        // CVE-2020-28483 - DoS
    github.com/dgrijalva/jwt-go v3.2.0+incompatible        // CVE-2020-26160 - JWT none alg bypass
    golang.org/x/crypto v0.0.0-20200109152110-61a87790db17 // CVE-2020-29652 - Nil pointer DoS
    golang.org/x/net v0.0.0-20200114155329-82b9add8e21b    // CVE-2021-33194 - DoS
    github.com/gogo/protobuf v1.3.1                        // CVE-2021-3121 - Unmarshal panic
    github.com/containerd/containerd v1.4.3                // CVE-2021-21334 - Info disclosure
    github.com/opencontainers/runc v1.0.0-rc92             // CVE-2021-30465 - Symlink race
    github.com/nats-io/nats-server/v2 v2.1.9               // CVE-2021-3127 - Auth bypass
    github.com/buger/jsonparser v1.0.0                     // CVE-2020-10675 - Panic on invalid input
    github.com/tidwall/gjson v1.6.0                        // CVE-2020-36067 - Panic DoS
    github.com/gorilla/websocket v1.4.0                    // CVE-2020-27813 - Integer overflow
    github.com/hashicorp/consul/api v1.3.0                 // CVE-2021-37219 - Raft RCE
    github.com/miekg/dns v1.1.25                           // CVE-2019-19794 - Insecure randomness
    github.com/prometheus/client_golang v1.7.0             // CVE-2022-21698 - ReDoS
    github.com/docker/distribution v2.7.1+incompatible     // CVE-2023-2253 - Memory exhaustion
    github.com/aws/aws-sdk-go v1.34.0                      // CVE-2020-8911 - CBC padding oracle
    gopkg.in/yaml.v2 v2.2.2                                // CVE-2019-11254 - DoS via large input
    github.com/helm/helm/v3 v3.5.0                         // CVE-2021-21303 - Path traversal
)
